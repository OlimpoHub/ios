//
//  BeneficiaryRequirement.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 11/11/25.
//

import Foundation

// Protocol and class for managing beneficiaries
protocol BeneficiaryListRequirementProtocol {
    // Fetches the list of beneficiaries
    func getBeneficiaryList() async -> [BeneficiaryResponse]?
    // Fetches a specific beneficiary by ID
    func getBeneficiary(id: String) async -> BeneficiaryResponse?
    // Clears stored beneficiary data
    func clearStorage() async -> Void
}

class BeneficiaryListRequirement: BeneficiaryListRequirementProtocol {
    static let shared = BeneficiaryListRequirement()

    let dataRepository: BeneficiaryRepositoryProtocol
    
    init(dataRepository: BeneficiaryRepositoryProtocol = CDBeneficiaryRepo.shared) {
        self.dataRepository = dataRepository
    }
    
    func getBeneficiaryList() async -> [BeneficiaryResponse]? {
        return await dataRepository.getBeneficiaries()
    }
    
    func getBeneficiary(id: String) async -> BeneficiaryResponse? {
        return await dataRepository.getBeneficiary(id: id)
    }
    
    func clearStorage() async {
        return await dataRepository.clearStorage()
    }
}
