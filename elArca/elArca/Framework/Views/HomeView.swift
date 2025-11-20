//
//  HomeView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 04/11/25.
//

import SwiftUI

enum UserHome {
    case collaborator
    case coordinator
    
    var items: [NavItem] {
        switch self {
        case .coordinator:
            return [
                NavItem(title: "Usuarios", icon: "Usuarios", screen: .users),
                NavItem(title: "Capacitaciones", icon: "Capacitaciones", screen: .capacitations),
                NavItem(title: "Análisis", icon: "Analisis", screen: .dashboard)
            ]
            
        case .collaborator:
            return [
                NavItem(title: "Capacitaciones", icon: "Capacitaciones", screen: .capacitations),
                NavItem(title: "Calendario", icon: "Analisis", screen: .calendar),
            ]
        }
    }
    
    var qrText: String {
        switch self {
        case .coordinator :
            return "Generar QR de Asistencia"
        case .collaborator :
            return "Registrar QR de Asistencia"
        }
    }
}

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var qrSize: CGFloat = hasBigScreen() ? 148 : 110
    
    var userHome: UserHome = .collaborator
    
    @EnvironmentObject var router: CoordinatorViewModel

    var body: some View {
        VStack {
            // Welcome and config
            HStack {
                // Name
                VStack(alignment: .leading) {
                    Texts(text: "Bienvenido,", type: .medium)
                    Texts(text: viewModel.userName, type: .header)
                }
                
                Spacer()
                
                HStack(spacing: 24) {
                    NotificationButton()
                    
                    SystemButton(icon: Image(systemName: "gear"), iconSize: 30) {
                        router.changeView(newScreen: .configuration)
                    }
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Attendance button
            MenuButton(text: userHome.qrText, height: qrSize, buttonType: .solid, image: .asset("QR"), screen: .attendance)
            
            Spacer()
            
            HStack(){
                Texts(text: "Menú principal", type: .header)
                Spacer()
            }
            
            Spacer()
            
            ForEach(userHome.items) { item in
                MenuButton(
                    text: item.title,
                    height: 110,
                    buttonType: .gradient,
                    image: .asset(item.icon),
                    screen: item.screen
                )
                Spacer()
            }
            
        }
        .padding(.horizontal, 24)
    }
}
