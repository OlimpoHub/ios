//
//  InMemoryCalendarItemsRepository.swift
//  elArca
//
//  Created by Fátima Figueroa on 03/11/25.
//
import Foundation

public final class InMemoryCalendarItemsRepository: CalendarItemsRepository {
    private var storage: [Date: [DayItem]] = [:]
    private let calendar: Calendar
    
    public init(calendar: Calendar = .current) {
        self.calendar = calendar
        // Datos de ejemplo
        let today = dayKey(Date(), calendar: calendar)
        storage[today] = [
            DayItem(title: "Vacunas", note: "Revisión general", date: today),
            DayItem(title: "Baño", note: "Shampoo medicado", date: today)
        ]
    }
    
    public func items(for day: Date) async -> [DayItem] {
        storage[dayKey(day, calendar: calendar)] ?? []
    }

    public func remove(_ item: DayItem) async {
        let k = dayKey(item.date, calendar: calendar)
        storage[k]?.removeAll { $0.id == item.id }
    }
}
