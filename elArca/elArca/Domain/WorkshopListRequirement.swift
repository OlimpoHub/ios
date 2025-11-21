//
//  WorkshopListRequirement.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 05/11/25.
//

import Foundation

protocol WorkshopListRequirementProtocol {
    func getWorkshopList() async -> [WorkshopResponse]?
    func getWorkshop(id: String) async -> WorkshopResponse?
}

class WorkshopListRequirement: WorkshopListRequirementProtocol {
    static let shared = WorkshopListRequirement()
    
    let dataRepository: WorkshopRepositoryProtocol
    
    init(dataRepository: WorkshopRepositoryProtocol = WorkshopRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func getWorkshopList() async -> [WorkshopResponse]? {
        return await dataRepository.getWorkshops()
    }
    
    func getWorkshop(id: String) async -> WorkshopResponse? {
        return await dataRepository.getWorkshop(id: id)
    }
}
