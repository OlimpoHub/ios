//
//  DayItem.swift
//  elArca
//
//  Created by Fátima Figueroa on 03/11/25.
//

import Foundation

// Struct representing a calendar day item
public struct DayItem: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let note: String
    public let date: Date
}

// Returns the start of the day for a given date
public func dayKey(_ date: Date, calendar: Calendar = .current) -> Date {
    calendar.startOfDay(for: date)
}
