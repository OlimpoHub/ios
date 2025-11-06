//
//  NotificationView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 05/11/25.
//

import SwiftUI
import FlowStacks

struct NotificationView: View {
    var notificationType: NotificationType
    
    @EnvironmentObject var navigator: FlowNavigator<Screen>
    
    var body: some View {
        VStack {
            SystemButton(icon: notificationType.icon, mainColor: notificationType.color, iconSize: 30) {
                // TODO: Redirección
            }
            RectangleButton(title: "Regresar", type: .largeBlue) {
                changeView(screen: .home, navigator: navigator)
            }
        }.navigationBarBackButtonHidden(true)
    }
}
