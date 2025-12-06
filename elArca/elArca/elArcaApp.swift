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

    // Used to change the views
    @StateObject var router = CoordinatorViewModel()

    @State var userNav: UserNav = .collaborator
    @State var notif: NotificationType = .with

    // Session store shared across app
    @StateObject private var session = SessionStore.shared
    
    // Network monitor to detect network changes
    @StateObject var network = NetworkMonitor.shared
    
    var body: some Scene {
        WindowGroup {
            AppBackground {
                CoordinatorView(userNav: $userNav, notificationType: $notif)
                    .environmentObject(network)
                    .environmentObject(router)
                    .environmentObject(deepLinkRouter)
                    .environmentObject(session)
                    .preferredColorScheme(.dark)
                    .buttonStyle(NoHighlightButtonStyle())
                    .onOpenURL { url in
                        deepLinkRouter.handle(url)
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    .onAppear {
                        // Restore locally-stored session; this keeps users logged in across app restarts
                        session.restoreSession()

                        // If session was cleared elsewhere, ensure router goes to login
                        if !session.isAuthenticated {
                            router.changeView(newScreen: .login)
                        } else {
                            // Keep current behavior: go to home when session appears valid locally
                            router.changeView(newScreen: .home)
                        }

                        // Observe global logout notifications and redirect to login
                        NotificationCenter.default.addObserver(forName: .authDidLogout, object: nil, queue: .main) { _ in
                            router.changeView(newScreen: .login)
                        }
                    }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
