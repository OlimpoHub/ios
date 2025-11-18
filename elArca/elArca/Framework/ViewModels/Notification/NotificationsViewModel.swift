//
//  NotificationsViewModel.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 17/11/25.
//

import Foundation
import Combine

@MainActor
class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationInfo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
        
    var notificationsRequirement: NotificationsRequirementProtocol
    
    init(notificationsRequirement: NotificationsRequirementProtocol = NotificationsRequirement.shared) {
        self.notificationsRequirement = notificationsRequirement
        loadNotifications()
    }
    
    // Obtains the user notifications
    func loadNotifications() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let result = await notificationsRequirement.fetchNotifications(userId: "1") // TODO: Cambiar a user ID al implementar con login
            
            if let notifications = result {
                self.notifications = notifications
            }
                        
            self.isLoading = false
        }
    }
}
