//
//  PasswordRequirement.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 18/11/25.
//

import Foundation

// Protocol and class for managing password-related operations
protocol PasswordRequirementProtocol {
    // Sends a recovery email to the user
    func requestRecoveryEmail(email: String) async throws
    // Verifies a recovery token and returns the associated email
    func verifyToken(token: String) async throws -> String
    // Updates the user's password
    func updatePassword(email: String, password: String) async throws
}

class PasswordRequirement: PasswordRequirementProtocol {
    static let shared = PasswordRequirement()

    let dataRepository: PasswordRepositoryProtocol
    
    init(dataRepository: PasswordRepositoryProtocol = PasswordRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func requestRecoveryEmail(email: String) async throws {
        try await dataRepository.requestRecoveryEmail(email: email)
    }
    
    func verifyToken(token: String) async throws -> String {
        return try await dataRepository.verifyToken(token: token)
    }
    
    func updatePassword(email: String, password: String) async throws {
        try await dataRepository.updatePassword(email: email, password: password)
    }
}
