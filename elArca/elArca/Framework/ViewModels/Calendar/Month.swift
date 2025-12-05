//
//  Month.swift
//  elArca
//
//  Created by Fátima Figueroa on 28/10/25.
//

import Foundation

// Represents a calendar month
struct Month: Identifiable, Equatable {
    let id: String // Unique identifier for the month
    let weeks: [Week] // Weeks in the month
    let order: Order // Order of the month
    let initializedDate: Date // Date used to initialize the month

    init(from date: Date, order: Order) {
        self.order = order // Set the order of the month

        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date) // Extract date components
        components.day = 15
        components.hour = 9
        components.minute = 0
        components.second = 0

        initializedDate = Calendar.current.date(from: components) ?? date

        let nearestMonday = Calendar.nearestMonday(from: initializedDate)
        let currentWeekDays = Calendar.currentWeek(from: nearestMonday)

        var weeks: [Week] = [
            Week(days: currentWeekDays, order: .current)
        ]

        var reachedLowerBound: Bool = false
        repeat {
            guard let week = weeks.first,
                  let firstDay = week.days.first,
                  let lastDay = week.days.last,
                  Calendar.isSameMonth(firstDay, lastDay)
            else {
                break
            }

            if let firstDay = weeks.first?.days.first {
                let previousWeekDays = Calendar.previousWeek(from: firstDay)

                if let lastDay = previousWeekDays.last, Calendar.isSameMonth(lastDay, firstDay) {
                    weeks.insert(
                        Week(days: previousWeekDays, order: .previous),
                        at: 0)
                }

                if let previousFirstDate = previousWeekDays.first, !Calendar.isSameMonth(previousFirstDate,firstDay) {
                    reachedLowerBound = true
                }
            } else {
                reachedLowerBound = true
            }
        } while !reachedLowerBound

        var reachedUpperBound: Bool = false
        repeat {
            if let lastDay = weeks.last?.days.last {
                let nextWeekDays = Calendar.nextWeek(from: lastDay)

                if let firstDay = nextWeekDays.first, Calendar.isSameMonth(firstDay, lastDay) {
                    weeks.append(Week(days: nextWeekDays, order: .next))
                }

                if let nextLastDate = nextWeekDays.last, !Calendar.isSameMonth(nextLastDate, lastDay) {
                    reachedUpperBound = true
                }
            } else {
                reachedUpperBound = true
            }
        } while !reachedUpperBound

        self.weeks = weeks
        self.id = Calendar.monthAndYear(from: initializedDate)
    }
}

extension Month {
    var previousMonth: Month? {
        guard let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: initializedDate) else { return nil }

        return Month(from: previousMonthDate, order: .previous)
    }

    var nextMonth: Month? {
        guard let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: initializedDate) else { return nil }

        return Month(from: nextMonthDate, order: .next)
    }

    enum Order {
        case previous, current, next
    }

    func theSameMonth(as date: Date) -> Bool {
        Calendar.isSameMonth(initializedDate, date)
    }
}
