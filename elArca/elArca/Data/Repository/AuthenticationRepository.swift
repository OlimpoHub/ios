//
//  AuthenticationRepository.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 12/11/25.
//

import Foundation


final class AuthenticationRepository: AuthenticationRequirementProtocol {
    static let shared = AuthenticationRepository()
    private init() {}

    private let authService = AuthService()
    private let tokenManager = TokenManager.shared

    func login(username: String, password: String) async throws -> LoginResponse {
        let response = try await authService.login(username: username, password: password)
        // Persist tokens using TokenManager (keep existing behavior)
        tokenManager.save(access: response.accessToken, refresh: response.refreshToken)

        // Persist the user id locally so the app can know which user is logged in
        UserDefaults.standard.set(response.user.id, forKey: "currentUserId")
        UserDefaults.standard.set(response.user.username, forKey: "currentUserName")

        // Also store role in keychain for SessionStore convenience
        KeychainHelper.shared.save(response.user.role ?? "", service: "com.elarca.auth", account: "userRole")

        // Also update the SessionStore observable state so UI can react immediately
        SessionStore.shared.persistSession(access: response.accessToken, refresh: response.refreshToken, role: response.user.role)

        return response
    }
}
