//
//  AuthenticationRequirement.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 12/11/25.
//


import Foundation


protocol AuthenticationRequirementProtocol {

    func login(username: String, password: String) async throws -> LoginResponse.User
}
