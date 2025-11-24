//
//  CalendarItemsRequirement.swift
//  elArca
//
//  Created by Fátima Figueroa on 03/11/25.
//

import Foundation

protocol CalendarItemsRequirement {
    func items(for day: Date) async -> [DayItem]
    func remove(_ item: DayItem) async
}
