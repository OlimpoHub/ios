//
//  NetworkClient.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 12/11/25.
//


import Foundation

enum AuthError: Error {
    case refreshFailed
}


final class TokenManager {
    static let shared = TokenManager()
    private init() {}

    private let keychain = KeychainHelper.shared
    private let service = "com.elarca.auth"
    private let accessAccount = "accessToken"
    private let refreshAccount = "refreshToken"

    // Internal actor that serializes the refreshTask management and performs the network refresh.
    private actor Refresher {
        var refreshTask: Task<String, Error>? = nil

        func getExistingTask() -> Task<String, Error>? { refreshTask }

        func startRefresh(refreshToken: String, authService: AuthService) -> Task<String, Error> {
            let task = Task<String, Error> {
                let resp = try await authService.refresh(refreshToken: refreshToken)
                // Return the access token; caller will persist it into Keychain.
                return resp.accessToken
            }
            refreshTask = task
            return task
        }

        func clearTask() {
            refreshTask = nil
        }
    }

    private let refresher = Refresher()


    func save(access: String, refresh: String) {
        keychain.save(access, service: service, account: accessAccount)
        keychain.save(refresh, service: service, account: refreshAccount)
    }

    func getAccess() -> String? {
        keychain.read(service: service, account: accessAccount)
    }

    func getRefresh() -> String? {
        keychain.read(service: service, account: refreshAccount)
    }

    func clear() {
        keychain.delete(service: service, account: accessAccount)
        keychain.delete(service: service, account: refreshAccount)
        NotificationCenter.default.post(name: .authDidLogout, object: nil)
    }


    func refreshAccessIfNeeded() async throws -> String {
        // First check: do we already have an in-flight refresh task? Ask the actor.
        if let existing = await refresher.getExistingTask() {
            return try await existing.value
        }

        // Make sure we have a refresh token
        guard let refreshToken = keychain.read(service: service, account: refreshAccount) else {
            // No refresh token -> clear and fail
            keychain.delete(service: service, account: accessAccount)
            keychain.delete(service: service, account: refreshAccount)
            NotificationCenter.default.post(name: .authDidLogout, object: nil)
            throw AuthError.refreshFailed
        }

        // Start a new refresh via the internal actor. The actor's Task performs only the network call.
        let task = await refresher.startRefresh(refreshToken: refreshToken, authService: AuthService())

        do {
            let token = try await task.value
            // Persist the new access token from outside the actor
            keychain.save(token, service: service, account: accessAccount)
            // clear the actor-held task
            await refresher.clearTask()
            return token
        } catch {
            // On failure clear tokens and notify UI
            await refresher.clearTask()
            keychain.delete(service: service, account: accessAccount)
            keychain.delete(service: service, account: refreshAccount)
            NotificationCenter.default.post(name: .authDidLogout, object: nil)
            throw AuthError.refreshFailed
        }
    }
}

extension Notification.Name {
    static let authDidLogout = Notification.Name("authDidLogout")
}
