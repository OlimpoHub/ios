//
//  SessionStore.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 21/11/25.
//

import Foundation
import Combine
import SwiftUI


@MainActor
class SessionStore: ObservableObject {
    static let shared = SessionStore()

    @Published private(set) var isAuthenticated: Bool = false
    @Published private(set) var userRole: String? = nil

    private let tokenManager = TokenManager.shared
    private var logoutObserver: Any?

    init() {
        // Subscribe to logout notifications to update state
        logoutObserver = NotificationCenter.default.addObserver(forName: .authDidLogout, object: nil, queue: .main) { [weak self] _ in
            self?.handleLogoutNotification()
        }
    }

    deinit {
        if let obs = logoutObserver {
            NotificationCenter.default.removeObserver(obs)
        }
    }

    func restoreSession() {
        // If we have a refresh token, consider user authenticated locally until we can validate with server
        if tokenManager.restoreSessionLocally() {
            isAuthenticated = true
            // userRole is saved separately (KeychainHelper usage in LoginView)
            userRole = KeychainHelper.shared.read(service: "com.elarca.auth", account: "userRole")
        } else {
            isAuthenticated = false
            userRole = nil
        }
    }

    func persistSession(access: String, refresh: String, role: String?) {
        tokenManager.save(access: access, refresh: refresh)
        if let r = role {
            KeychainHelper.shared.save(r, service: "com.elarca.auth", account: "userRole")
            self.userRole = r
        }
        isAuthenticated = true
    }

    func clearSession() {
        tokenManager.clear()
        KeychainHelper.shared.delete(service: "com.elarca.auth", account: "userRole")
        UserDefaults.standard.removeObject(forKey: "currentUserId")
        UserDefaults.standard.removeObject(forKey: "currentUserName")
        isAuthenticated = false
        userRole = nil
    }

    private func handleLogoutNotification() {
        // Called when tokens are cleared globally
        isAuthenticated = false
        userRole = nil
    }
}
