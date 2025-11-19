//
//  elArcaApp.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 20/10/25.
//

import SwiftUI
import FlowStacks

@main
struct elArcaApp: App {
    @StateObject private var deepLinkRouter = DeepLinkRouter()

    var body: some Scene {
        WindowGroup {
            AppBackground {
                CoordinatorView()
                    .preferredColorScheme(.dark)
                    .environmentObject(deepLinkRouter)
                    .onOpenURL { url in
                        deepLinkRouter.handle(url)
                    }
    // Used to change the views
    @StateObject var router = CoordinatorViewModel()
    
    @State var userNav: UserNav = .collaborator
    @State var notif: NotificationType = .with
    
    var body: some Scene {
        WindowGroup {
            AppBackground {
                CoordinatorView(userNav: $userNav, notificationType: $notif).preferredColorScheme(.dark)
                    .environmentObject(router)
            }
        }
    }
}
