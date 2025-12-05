//
//  NotificationsRequirement.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 17/11/25.
//

// Protocol and class for managing notifications
protocol NotificationsRequirementProtocol {
    // Fetches notifications for a specific user
    func fetchNotifications(userId: String) async -> [NotificationInfo]?
    // Checks if a user has new notifications
    func hasNewNotifications(userId: String) async -> Bool
    // Marks a notification as read
    func readNotification(notificationId: String) async
}

class NotificationsRequirement: NotificationsRequirementProtocol {
    static let shared = NotificationsRequirement()

    let dataRepository: NotificationRepositoryProtocol
    
    init(dataRepository: NotificationRepositoryProtocol = NotificationRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func fetchNotifications(userId: String) async -> [NotificationInfo]? {
        return await dataRepository.fetchNotifications(userId: userId)
    }
    
    func hasNewNotifications(userId: String) async -> Bool {
        return await dataRepository.hasNewNotifications(userId: userId)
    }
    
    func readNotification(notificationId: String) async {
        await dataRepository.readNotifications(notificationId: notificationId)
    }

}
