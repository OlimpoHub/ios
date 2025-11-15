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

    var body: some View {
        
        VStack(spacing: 0) {
            TabView(selection: $router.screen) {
                Text("No existo")
                    .toolbar(.hidden, for: .tabBar)
                
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
            }
            
            if router.screen.isNavbarViewable {
                NavBar(userNav: userNav)
            }
        }
        
    }
}
