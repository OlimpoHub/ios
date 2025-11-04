//
//  CalendarItemsRepository.swift
//  elArca
//
//  Created by Fátima Figueroa on 03/11/25.
//

import Foundation

public protocol CalendarItemsRepository {
    func items(for day: Date) async -> [DayItem]
    func remove(_ item: DayItem) async
}
