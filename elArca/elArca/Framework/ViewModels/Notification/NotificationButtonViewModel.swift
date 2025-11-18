//
//  NotificationButtonViewModel.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 18/11/25.
//

import Foundation
import Combine

@MainActor
class NotificationButtonViewModel: ObservableObject {
    @Published var hasNewNotifications: Bool = false
            
    var notificationsRequirement: NotificationsRequirementProtocol
        
    init(notificationsRequirement: NotificationsRequirementProtocol = NotificationsRequirement.shared) {
        self.notificationsRequirement = notificationsRequirement
    }
    
    // Verifies for new notifications
    func updateNotifications() async -> Bool {
        hasNewNotifications = await notificationsRequirement.hasNewNotifications(userId: "1") // TODO: Change to real users
        return hasNewNotifications
    }
}
