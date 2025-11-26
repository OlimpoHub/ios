//
//  CDCalendarItemsRepo.swift
//  elArca
//
//  Created by Fátima Figueroa on 11/11/25.
//

import Foundation
import CoreData

final class CDCalendarItemsRepo: CalendarItemsRequirement {
    private let stack: CoreDataStack
    private let service: CalendarService
    private let calendar: Calendar = .current
    private var didAttemptSync = false

    init(stack: CoreDataStack = .shared, service: CalendarService = .shared) {
        self.stack = stack
        self.service = service
    }

    // Public API
    func items(for day: Date) async -> [DayItem] {
        // 1) Attempts to synchronize once per boot (does not block if there is no network)
        if !didAttemptSync {
            didAttemptSync = true
            Task.detached { [weak self] in await self?.sync() }
        }

        // 2) reads from local cache
        let ctx = stack.viewContext
        let (start, end) = dayBounds(for: day)

        let req: NSFetchRequest<CDCalendarItem> = CDCalendarItem.fetchRequest()
        req.predicate = NSPredicate(format: "fecha >= %@ AND fecha < %@", start as NSDate, end as NSDate)
        req.sortDescriptors = [
            NSSortDescriptor(key: "fecha", ascending: true),
            NSSortDescriptor(key: "horaEntrada", ascending: true)
        ]

        do {
            let rows = try ctx.fetch(req)
            return rows.map { row in
                let entrada = formatoHora(row.horaEntrada)
                let salida  = formatoHora(row.horaSalida)
                let detalle = "Horario: \(entrada) - \(salida)"
                return DayItem(title: row.nombreTaller, note: detalle, date: row.fecha)
            }
        } catch {
            print("CoreData fetch error:", error)
            return []
        }
    }

    func remove(_ item: DayItem) async {
        let ctx = stack.viewContext
        let req: NSFetchRequest<CDCalendarItem> = CDCalendarItem.fetchRequest()
        req.predicate = NSPredicate(format: "fecha == %@ AND nombreTaller == %@",
                                    item.date as NSDate, item.title)

        do {
            let rows = try ctx.fetch(req)
            rows.forEach { ctx.delete($0) }
            try ctx.save()
        } catch {
            print("CoreData delete error:", error)
        }
    }

    // Sync (API -> Core Data)
    func sync() async {
        guard let baseURL = URL(string: Api.base) else { return }

        do {
            let remote = try await service.getCalendarList(
                baseURL: baseURL,
                path: Api.routes.calendar,
                limit: nil
            )

            print("Sync: la API regresó \(remote.count) talleres")

            let ctx = stack.newBackgroundContext()

            try await ctx.perform {
                // 1) Erase what was before
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDCalendarItem")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
                try ctx.execute(deleteRequest)

                // 2) Insert new items
                for info in remote {
                    let obj = CDCalendarItem(context: ctx)
                    obj.idTaller       = info.idTaller
                    obj.idUsuario      = info.idUsuario
                    obj.nombreTaller   = info.nombreTaller
                    obj.fecha          = info.fecha
                    obj.horaEntrada    = info.horaEntrada
                    obj.horaSalida     = info.horaSalida
                }

                if ctx.hasChanges { try ctx.save() }
            }

            let viewCtx = stack.viewContext
            let countReq: NSFetchRequest<CDCalendarItem> = CDCalendarItem.fetchRequest()
            let total = (try? viewCtx.count(for: countReq)) ?? -1
            print("Core Data ahora tiene \(total) talleres guardados")

        } catch {
            print("Sync falló (offline sigue funcionando):", error)
        }
    }

    // Helpers
    private func dayBounds(for day: Date) -> (Date, Date) {
        let start = calendar.startOfDay(for: day)
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        return (start, end)
    }

    private func formatoHora(_ h: String) -> String {
        guard !h.isEmpty else { return "—" }
        let inFmt = DateFormatter()
        inFmt.dateFormat = "HH:mm:ss"
        inFmt.locale = Locale(identifier: "en_US_POSIX")

        let outFmt = DateFormatter()
        outFmt.dateFormat = "h:mm a"
        outFmt.locale = Locale(identifier: "es_MX")
        outFmt.amSymbol = "a.m."
        outFmt.pmSymbol = "p.m."

        if let d = inFmt.date(from: h) {
            return outFmt.string(from: d) }
        return h
    }
}
