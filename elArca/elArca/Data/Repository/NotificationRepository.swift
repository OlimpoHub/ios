//
//  NotificationRepository.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 17/11/25.
//

// Notification repository responsible for fetching and marking notifications.
// - Uses NotificationService to request data from the backend.
// - Methods return decoded NotificationInfo models or simple flags.

import Foundation

protocol NotificationRepositoryProtocol {
    func fetchNotifications(userId: String) async -> [NotificationInfo]?
    func hasNewNotifications(userId: String) async -> Bool
    func readNotifications(notificationId: String) async -> Void
}

final class NotificationRepository: NotificationRepositoryProtocol {
    static let shared = NotificationRepository()
    
    private var storage: [NotificationInfo] = []
    private var didLoadFromAPI = false

    init() {}
    
    // Obtains the user notifications
    // - Returns an array of NotificationInfo or empty array on error.
    func fetchNotifications(userId: String) async -> [NotificationInfo]? {
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return []
        }

        do {
            print("Fetching notifications from: \(baseURL.appendingPathComponent(Api.routes.notifications).absoluteString)fetch")
            let result = try await NotificationService.shared.fetchNotifications(
                baseURL: baseURL,
                userId: userId
            )
            .sorted()

            print("Successfully fetched and stored \(result.count) notifications")
                        
            return result
        } catch {
            print("Error whilst loading notifications: \(error)")
            print("Error details: \(error.localizedDescription)")
            return []
        }
    }
    
    // Checks if the user has notifications left to read
    func hasNewNotifications(userId: String) async -> Bool {
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return false
        }
        
        do {
            let result = try await NotificationService.shared.fetchNewNotifications(baseURL: baseURL, userId: userId)
            return result.size > 0
        } catch {
            print("Error fetching notifications: \(error)")
            return false
        }
    }
    
    // Marks a notification as read (fire and forget)
    func readNotifications(notificationId: String) async {
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return
        }
        
        do {
            try await NotificationService.shared.readNotification(
                baseURL: baseURL,
                notificationId: notificationId
            )
        } catch {
            print("Error fetching notifications: \(error)")
        }
    }
}
