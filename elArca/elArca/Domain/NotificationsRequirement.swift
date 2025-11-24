//
//  NotificationsRequirement.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 17/11/25.
//

protocol NotificationsRequirementProtocol {
    func fetchNotifications(userId: String) async -> [NotificationInfo]?
    func hasNewNotifications(userId: String) async -> Bool
    func readNotification(notificationId: String) async
}

class NotificationsRequirement: NotificationsRequirementProtocol {
    static let shared = NotificationsRequirement()
    
    let dataRepository: NotificationRepositoryProtocol
    
    init(dataRepository: NotificationRepositoryProtocol = NotificationRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    // Obtains the user notifications
    func fetchNotifications(userId: String) async -> [NotificationInfo]? {
        return await dataRepository.fetchNotifications(userId: userId)
    }
    
    // Obtains the amount of notifications the user hasn't seen
    func hasNewNotifications(userId: String) async -> Bool {
        return await dataRepository.hasNewNotifications(userId: userId)
    }
    
    // Marks a notification as read
    func readNotification(notificationId: String) async {
        await dataRepository.readNotifications(notificationId: notificationId)
    }

}
