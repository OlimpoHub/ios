//
//  NotificationDetailViewModel.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 18/11/25.
//

import Foundation
import Combine

@MainActor
class NotificationDetailViewModel: ObservableObject {
    var notificationsRequirement: NotificationsRequirementProtocol
    
    init(notificationsRequirement: NotificationsRequirementProtocol = NotificationsRequirement.shared) {
        self.notificationsRequirement = notificationsRequirement
    }
    
    // Reads a notification
    func readNotification(notification: String) {
        Task {
            await notificationsRequirement.readNotification(notificationId: notification)
        }
    }
}
