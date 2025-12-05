//
//  Week.swift
//  elArca
//
//  Created by Fátima Figueroa on 29/10/25.
//

import Foundation

// Represents a calendar week
struct Week: Hashable, Identifiable {
    let id: String
    let days: [Date]
    let order: Order
    
    init(days: [Date], order: Order) {
        self.id = Calendar.weekAndYear(from: days.last ?? .now)
        self.days = days
        self.order = order
    }
    
    enum Order {
        case previous, current, next
    }
}

extension Week: Equatable {
    // Compares two weeks based on their IDs
    static func == (lhs: Week, rhs: Week) -> Bool {
        lhs.id == rhs.id
    }
}

extension Week {
    // Represents the current week
    static let current = Week(days: Calendar.currentWeek(from: Calendar.nearestMonday(from: .now)), order: .current)
}
