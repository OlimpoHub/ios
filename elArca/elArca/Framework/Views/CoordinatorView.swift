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
                
<<<<<<< HEAD
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
                    
                default:
                    Text("Nothing")
                }
=======
                LoginView()
                    .tag(Screen.login)
                    .toolbar(.hidden, for: .tabBar)
                
                HomeView()
                    .tag(Screen.home)
                    .toolbar(.hidden, for: .tabBar)
                
                NotificationView(notificationType: notificationType)
                    .tag(Screen.notifications)
                    .toolbar(.hidden, for: .tabBar)
                
                WorkshopView()
                    .navigationBarBackButtonHidden(true)
                    .tag(Screen.workshop)
                    .toolbar(.hidden, for: .tabBar)
                
                
                CalendarView()
                    .tag(Screen.calendar)
                    .toolbar(.hidden, for: .tabBar)
                
                // TODO: Renombrar a beneficiaryView
                Beneficiary()
                    .tag(Screen.beneficiaries)
                    .toolbar(.hidden, for: .tabBar)
                
                ReadQRView(viewModel: attendanceVM)
                    .tag(Screen.attendance)
                    .toolbar(.hidden, for: .tabBar)
>>>>>>> 9f029e2b98ac68c4d0072a168fa91cbf14eeacd4
            }
            .background(Color("Bg"))
            
            if router.screen.isNavbarViewable {
                NavBar(userNav: userNav)
            }
        }
    }
}
