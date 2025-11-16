//
//  BeneficiaryRequirement.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 11/11/25.
//

import Foundation

protocol BeneficiaryListRequirementProtocol {
    func getBeneficiaryList() async -> [BeneficiaryResponse]?
    func getBeneficiary(id: String) async -> BeneficiaryResponse?
}

class BeneficiaryListRequirement: BeneficiaryListRequirementProtocol {
    static let shared = BeneficiaryListRequirement()
    
    let dataRepository: BeneficiaryRepositoryProtocol
    
    init(dataRepository: BeneficiaryRepositoryProtocol = BeneficiaryRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func getBeneficiaryList() async -> [BeneficiaryResponse]? {
        return await dataRepository.getBeneficiaries()
    }
    
    func getBeneficiary(id: String) async -> BeneficiaryResponse? {
        return await dataRepository.getBeneficiary(id: id)
    }
}
