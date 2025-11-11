//
//  CalendarItemsRepository.swift
//  elArca
//
//  Created by Fátima Figueroa on 03/11/25.
//

import Foundation


final class CalendarItemsRepository: CalendarItemsRequirement {
    private var storage: [Date: [DayItem]] = [:]
    private let calendar: Calendar = .current
    private var didLoadFromAPI = false

    private func ensureLoaded() async {
        guard !didLoadFromAPI else { return }
        didLoadFromAPI = true
        guard let baseURL = URL(string: Api.base) else { return }

        do {
            let remote: [CalendarInfo] = try await CalendarService.shared.getCalendarList(baseURL: baseURL, path: Api.routes.calendar, limit: nil)

            // Group per day
            var tmp: [Date: [DayItem]] = [:]
            for info in remote {
                let k = dayKey(info.fecha, calendar: calendar)
                let item = DayItem(
                    title: info.nombreTaller,
                    note: "Horario: \(info.horarioTaller)",
                    date: info.fecha
                )
                tmp[k, default: []].append(item)
            }
            storage = tmp
        } catch {
        }
    }

    func items(for day: Date) async -> [DayItem] {
        await ensureLoaded()
        return storage[dayKey(day, calendar: calendar)] ?? []
    }

    func remove(_ item: DayItem) async {
        let k = dayKey(item.date, calendar: calendar)
        storage[k]?.removeAll { $0.id == item.id }
    }
}
