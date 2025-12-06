//
//  CalendarItemsRequirement.swift
//  elArca
//
//  Created by Fátima Figueroa on 03/11/25.
//

import Foundation

// Protocol and class for managing calendar items
protocol CalendarItemsRequirementProtocol {
    // Retrieves calendar items for a specific day
    func items(for day: Date) async -> [DayItem]
    // Removes a specific calendar item
    func remove(_ item: DayItem) async
}

class CalendarItemsRequirement: CalendarItemsRequirementProtocol {
    static let shared = CalendarItemsRequirement()

    let dataRepository: CalendarItemsRepositoryProtocol
    
    init(dataRepository: CalendarItemsRepositoryProtocol = CDCalendarItemsRepo.shared) {
        self.dataRepository = dataRepository
    }
    
    func items(for day: Date) async -> [DayItem] {
        return await dataRepository.items(for: day)
    }
    
    func remove(_ item: DayItem) async {
        await dataRepository.remove(item)
    }
}
