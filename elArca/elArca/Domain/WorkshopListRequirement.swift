//
//  WorkshopListRequirement.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 05/11/25.
//

import Foundation

// Protocol and class for managing workshops
protocol WorkshopListRequirementProtocol {
    // Fetches the list of workshops
    func getWorkshopList() async -> [WorkshopResponse]?
    // Fetches a specific workshop by ID
    func getWorkshop(id: String) async -> WorkshopResponse?
    // Clears stored workshop data
    func clearStorage() async -> Void
}

class WorkshopListRequirement: WorkshopListRequirementProtocol {
    static let shared = WorkshopListRequirement()

    let dataRepository: WorkshopRepositoryProtocol
    
    // offline-first
    init(dataRepository: WorkshopRepositoryProtocol = CDWorkshopRepo.shared) {
        self.dataRepository = dataRepository
    }
    
    func getWorkshopList() async -> [WorkshopResponse]? {
        return await dataRepository.getWorkshops()
    }
    
    func getWorkshop(id: String) async -> WorkshopResponse? {
        return await dataRepository.getWorkshop(id: id)
    }
    
    func clearStorage() async {
        return await dataRepository.clearStorage()
    }
}
