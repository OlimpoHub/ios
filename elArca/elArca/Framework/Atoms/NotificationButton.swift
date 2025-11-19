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
    @StateObject var viewModel = NotificationButtonViewModel()
    
    @EnvironmentObject var router: CoordinatorViewModel
    
    var body: some View {
        var notificationType: NotificationType = viewModel.hasNewNotifications ? .with : .without
        
        SystemButton(icon: notificationType.icon, mainColor: notificationType.color, iconSize: 30) {
            router.push(newScreen: .notifications)
        }

        .onAppear() {
            Task {
                notificationType = await viewModel.updateNotifications() ? .with : .without
            }
        }
    }
}
