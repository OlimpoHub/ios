//
//  AuthenticationRequirement.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 12/11/25.
//

import Foundation

// Protocol for user authentication
protocol AuthenticationRequirementProtocol {

    // Logs in a user with username and password
    func login(username: String, password: String) async throws -> LoginResponse
}
