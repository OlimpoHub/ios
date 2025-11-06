//
//  CoordinatorView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 04/11/25.
//

import FlowStacks
import SwiftUI

enum Screen {
    case home
    case notifications
    case users
    case capatications
    case analisis //TODO: Nombre chido
}

enum Account {
    case logged
    case notLogged
}

struct CoordinatorView: View {
    @State var routes: [Route<Screen>] = []
    @State var accountRoute: [Route<Account>] = []
    
    var navBar = NavBar()
    
    var body: some View {
        FlowStack($accountRoute, withNavigation: true) {
            // Set home destination
            LoginView()
            .flowDestination(for: Account.self) { account in
                switch account {
                case .logged:
                    
                    VStack(spacing: 0) {
                        FlowStack($routes, withNavigation: true) {
                            // Set home destination
                            HomeView()
                            .flowDestination(for: Screen.self) { screen in
                                switch screen {
                                case .home:
                                    HomeView()
                                case .notifications:
                                    NotificationView(notificationType: .with)
                                default:
                                    Text("Nada")
                                }
                            }
                        }
                                                                                                
                        NavBar()
                        
                    }                        
                    
                default:
                    Text("Nada")
                }
            }
        }
    }
}

#Preview {
    AppBackground {
        CoordinatorView().preferredColorScheme(.dark)
    }
}
