//
//  CalendarItemsRequirement.swift
//  elArca
//
//  Created by Fátima Figueroa on 03/11/25.
//

import Foundation

protocol CalendarItemsRequirementProtocol {
    func items(for day: Date) async -> [DayItem]
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
