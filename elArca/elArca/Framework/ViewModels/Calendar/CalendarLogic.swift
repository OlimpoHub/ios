//
//  CalendarLogic.swift
//  elArca
//
//  Created by Fátima Figueroa on 03/11/25.
//

import Foundation

// Calendar extension for custom date logic
extension Calendar {
    // Finds the nearest Monday from a given date
    static func nearestMonday(from date: Date = .now) -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let daysToSubstract = (weekday - 2 + 7) % 7
        let nearestMonday = calendar.date(byAdding: .day, value: -daysToSubstract, to: date)!
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nearestMonday)
        dateComponents.hour = 9
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return Calendar.current.date(from: dateComponents) ?? nearestMonday
    }
    
    // Returns the dates of the current week from a given date
    static func currentWeek(from date: Date = .now) -> [Date] {
        let calendar = Calendar.current
        return (0...6).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: date)
        }
    }
    
    // Returns the dates of the next week from a given date
    static func nextWeek(from date: Date = .now) -> [Date] {
        let calendar = Calendar.current
        return (1...7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: date)
        }
    }
    
    // Returns the dates of the previous week from a given date
    static func previousWeek(from date: Date = .now) -> [Date] {
        let calendar = Calendar.current
        return (1...7).compactMap { offset in
            calendar.date(byAdding: .day, value: -(6 - offset + 2), to: date)
        }
    }
    
    // Extracts the day number from a given date
    static func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    
    // Extracts the day letter from a given date
    static func dayLetter(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date)
    }
    
    // Extracts the week number and year from a given date
    static func weekAndYear(from date: Date) -> String {
        let calendar = Calendar.current
        let weekNumber = calendar.component(.weekOfYear, from: date)
        let year = calendar.component(.yearForWeekOfYear, from: date)
        return "\(weekNumber)-\(year)"
    }
    
    // Extracts the month and year from a given date
    static func monthAndYear(from date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "MMMM"
        
        let month = formatter.string(from: date).capitalized
        let year = calendar.component(.year, from: date)
        
        return "\(month) \(year)"
    }
    
    // Checks if two dates are in the same month
    static func isSameMonth(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month], from: date1)
        let components2 = calendar.dateComponents([.year, .month], from: date2)
        return components1.year == components2.year && components1.month == components2.month
    }
}
