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
    case capacitations
    case dashboard
    case workshop
    case calendar
    case beneficiaries
    case inventory
    case orders
    case assistance
    case configuration
}

enum Account {
    case logged
    case notLogged
}

struct CoordinatorView: View {
    @State var routes: [Route<Screen>] = []
    @State var accountRoute: [Route<Account>] = []
        
    var body: some View {
        FlowStack($accountRoute, withNavigation: true) {
            // Set home destination
            LoginView()
            .flowDestination(for: Account.self) { account in
                switch account {
                case .logged:
                    
                    ZStack {
                        FlowStack($routes, withNavigation: true) {
                            // Set home destination
                            VStack(spacing: 0) {
                                HomeView(userHome: .coordinator)
                                NavBar(userNav: .collaborator)
                            }
                            .flowDestination(for: Screen.self) { screen in
                                switch screen {
                                case .home:
                                    HomeView(userHome: .coordinator)
                                case .notifications:
                                    NotificationView(notificationType: .with)
                                case .users:
                                    VStack {
                                        Text("Usuarios")
                                        Spacer()
                                    }
                                case .capacitations:
                                    VStack {
                                        Text("Capacitaciones")
                                        Spacer()
                                    }
                                case .dashboard:
                                    VStack {
                                        Text("Analisis")
                                        Spacer()
                                    }
                                case .workshop:
                                    VStack {
                                        Text("Talleres")
                                        Spacer()
                                    }
                                case .calendar:
                                    VStack {
                                        Text("Calendario")
                                        Spacer()
                                    }
                                case .beneficiaries:
                                    VStack {
                                        Text("Beneficiarios")
                                        Spacer()
                                    }
                                case .inventory:
                                    VStack {
                                        Text("Inventario")
                                        Spacer()
                                    }
                                case .orders:
                                    VStack {
                                        Text("Pedidos")
                                        Spacer()
                                    }
                                case .assistance:
                                    VStack {
                                        Text("Asistencias")
                                        Spacer()
                                    }
                                case .configuration:
                                    VStack {
                                        Text("Configuracion")
                                        Spacer()
                                    }
                                default:
                                    VStack {
                                        Text("Nada")
                                        Spacer()
                                    }
                                }
                                
                                NavBar(userNav: .collaborator)
                            }
                        }.zIndex(1)
                        
                        VStack {
                            Spacer()
                            NavBar(userNav: .collaborator)
                        }
                        .zIndex(2)
                        .allowsHitTesting(false)
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
