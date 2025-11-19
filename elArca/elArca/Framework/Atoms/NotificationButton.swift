//
//  NotificationButton.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 04/11/25.
//

import SwiftUI
import FlowStacks

enum NotificationType {
    case with
    case without
    
    var icon: Image {
        switch self {
        case .with:
            return Image(systemName: "bell.badge.fill").symbolRenderingMode(.palette)
        case .without:
            return Image(systemName: "bell.fill")
        }
    }
    
    var color: Color {
        switch self {
        case .with:
            return Color("HighlightBlue")
        case .without:
            return Color("Beige")
        }
    }
}

struct NotificationButton: View {
    var notificationType: NotificationType = .with
    
    @EnvironmentObject var router: CoordinatorViewModel
    
    var body: some View {
        
        SystemButton(icon: notificationType.icon, mainColor: notificationType.color, iconSize: 30) {
            router.changeView(newScreen: .notifications)
        }
        
    }
}
