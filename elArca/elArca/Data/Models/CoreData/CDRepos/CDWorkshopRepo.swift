//
//  CDWorkshopRepo.swift
//  elArca
//
//  Created by Fátima Figueroa on 25/11/25.
//

import Foundation
import CoreData

final class CDWorkshopRepo: WorkshopRepositoryProtocol {

    static let shared = CDWorkshopRepo()

    private let stack: CoreDataStack
    private let service: WorkshopService
    private var didAttemptSync = false

    init(
        stack: CoreDataStack = .shared,
        service: WorkshopService = .shared
    ) {
        self.stack = stack
        self.service = service
    }

    // Launches a background sync only once per lifecycle
    private func ensureSyncedOnce() {
        guard !didAttemptSync else { return }
        didAttemptSync = true

        Task.detached { [weak self] in
            await self?.sync()
        }
    }


    func getWorkshops() async -> [WorkshopResponse]? {
        ensureSyncedOnce()

        let ctx = stack.viewContext
        let req: NSFetchRequest<CDWorkshops> = CDWorkshops.fetchRequest()
        req.sortDescriptors = [
            NSSortDescriptor(key: "fecha", ascending: true),
            NSSortDescriptor(key: "nombreTaller", ascending: true)
        ]

        do {
            let rows = try ctx.fetch(req)
            return rows.map { $0.toDTO() }
        } catch {
            print("CoreData fetch workshops error:", error)
            return nil
        }
    }

    func getWorkshop(id: String) async -> WorkshopResponse? {
        let ctx = stack.viewContext
        let req: NSFetchRequest<CDWorkshops> = CDWorkshops.fetchRequest()
        req.predicate = NSPredicate(format: "idTaller == %@", id)

        do {
            if let row = try ctx.fetch(req).first {
                // local cache
                return row.toDTO()
            }
        } catch {
            print("CoreData fetch single workshop error:", error)
        }

        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return nil
        }

        do {
            let dto = try await service.getWorkshop(
                baseURL: baseURL,
                path: Api.routes.workshops,
                id: id
            )

            // Save in Core Data
            let bgCtx = stack.newBackgroundContext()
            try await bgCtx.perform {
                let obj = CDWorkshops(context: bgCtx)
                obj.populate(from: dto)
                if bgCtx.hasChanges {
                    try bgCtx.save()
                }
            }

            return dto
        } catch {
            print("Error fetching workshop from API with id \(id):", error)
            return nil
        }
    }

    // Sync (API -> Core Data)
    func sync() async {
        guard let baseURL = URL(string: Api.base) else {
            print("Api.base inválida")
            return
        }

        do {
            let remote = try await service.getWorkshops(
                baseURL: baseURL,
                path: Api.routes.workshops
            )

            print("Sync Workshops: la API regresó \(remote.count) talleres")

            let ctx = stack.newBackgroundContext()

            try await ctx.perform {
                // Clean the previous ones
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDWorkshops")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
                try ctx.execute(deleteRequest)

                // Insert new
                for dto in remote {
                    let obj = CDWorkshops(context: ctx)
                    obj.populate(from: dto)
                }

                if ctx.hasChanges {
                    try ctx.save()
                }
            }

            // Count how many there are
            let viewCtx = stack.viewContext
            let countReq: NSFetchRequest<CDWorkshops> = CDWorkshops.fetchRequest()
            let total = (try? viewCtx.count(for: countReq)) ?? -1
            print("Core Data Workshops ahora tiene \(total) registros guardados")

        } catch {
            print("Sync Workshops falló (offline sigue funcionando):", error)
        }
    }
}

