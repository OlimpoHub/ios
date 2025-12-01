//
//  collaboratorView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 04/11/25.
//

import Combine
import SwiftUI

struct CoordinatorView: View {
    @EnvironmentObject var network: NetworkMonitor
    @Binding var userNav: UserNav
    @Binding var notificationType: NotificationType
    
    @EnvironmentObject var router: CoordinatorViewModel
    @StateObject private var attendanceVM = AttendanceViewModel()
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            if network.isConnected {
                OfflineBadge()
            }
            
            // Todas las pantallas
            Group {
                switch router.screen {
                case .login:
                    LoginView()
                case .home:
                    HomeView()
                case .notifications:
                    NotificationView(notificationType: notificationType)
                case .workshop:
                    WorkshopView()
                case .calendar:
                    CalendarView()
                case .beneficiaries:
                    Beneficiary()
                case .attendance:
                    VStack {
                        Spacer()
                        ReadQRView(viewModel: AttendanceViewModel())
                        Spacer()
                    }
                case .configuration:
                    ConfigurationView()
                default:
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Texts(text: "En proceso...", type: .header)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Bg"))
            
            if router.screen.isNavbarViewable {
                NavBar(userNav: userNav)
                    .frame(height: 65)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
