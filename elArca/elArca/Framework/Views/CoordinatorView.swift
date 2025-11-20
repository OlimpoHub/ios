//
//  collaboratorView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 04/11/25.
//

import Combine
import SwiftUI

struct CoordinatorView: View {
    @Binding var userNav: UserNav
    @Binding var notificationType: NotificationType
    
    // Lets the screens change
    @EnvironmentObject var router: CoordinatorViewModel
    @StateObject private var attendanceVM = AttendanceViewModel()
    
    var body: some View {
        
        VStack(spacing: 0) {
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
            .background(Color("Bg"))
            
            if router.screen.isNavbarViewable {
                NavBar(userNav: userNav)
            }
        }
    }
}
