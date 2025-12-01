//
//  TokenManager.swift
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


    func isRefreshTokenExpired() -> Bool? {
        guard let refresh = getRefresh() else { return nil }
        return JWTDecoder.isExpired(refresh)
    }


    func restoreSessionLocally() -> Bool {
        guard let refresh = getRefresh() else {
            keychain.delete(service: service, account: accessAccount)
            keychain.delete(service: service, account: refreshAccount)
            return false
        }

        if let expired = JWTDecoder.isExpired(refresh) {
            if expired {
                // Refresh token expired -> clear tokens and report no session
                keychain.delete(service: service, account: accessAccount)
                keychain.delete(service: service, account: refreshAccount)
                NotificationCenter.default.post(name: .authDidLogout, object: nil)
                return false
            } else {
                // Refresh token present and not expired
                return true
            }
        }

        // Couldn't decode exp -> conservative choice: keep session locally active until server validation
        return true
    }
}

extension Notification.Name {
    static let authDidLogout = Notification.Name("authDidLogout")
}

// DEBUG helpers for testing expired tokens

extension TokenManager {
    func makeExpiredJWT(secondsAgo: Int = 3600) -> String {
        func base64UrlEncode(_ data: Data) -> String {
            return data.base64EncodedString()
                .replacingOccurrences(of: "+", with: "-")
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: "=", with: "")
        }

        let header: [String: Any] = ["alg": "none", "typ": "JWT"]
        let exp = Int(Date().timeIntervalSince1970) - secondsAgo
        let payload: [String: Any] = ["sub": "debug-user", "exp": exp]

        let headerData = try! JSONSerialization.data(withJSONObject: header)
        let payloadData = try! JSONSerialization.data(withJSONObject: payload)

        let headerPart = base64UrlEncode(headerData)
        let payloadPart = base64UrlEncode(payloadData)

        return "\(headerPart).\(payloadPart)."
    }

    func debugExpireRefreshToken(secondsAgo: Int = 3600) {
        let expired = makeExpiredJWT(secondsAgo: secondsAgo)
        KeychainHelper.shared.save(expired, service: service, account: refreshAccount)
        KeychainHelper.shared.save("debug-access-token", service: service, account: accessAccount)

        // Run restore; since the token is expired, restoreSessionLocally() will clear tokens and post logout
        _ = restoreSessionLocally()
    }
}

