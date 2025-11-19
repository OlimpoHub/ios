//
//  NotificationView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 05/11/25.
//

import SwiftUI

struct NotificationView: View {
    var notificationType: NotificationType
    
    @StateObject private var viewModel = NotificationsViewModel()
    
    @EnvironmentObject var router: CoordinatorViewModel
    
    var body: some View {
        NavigationStack() {
            VStack(spacing: 0) {
                HStack {                    
                    Texts(text: "Notificaciones", type: .header)
                        .foregroundColor(.white)
                    
                    Spacer()

                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                mainContent
            }
            .background(Color("Bg"))
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                    .frame(maxHeight: .infinity)
                
            } else if viewModel.notifications.isEmpty {

                Texts(text: "¡No tiene notificaciones actualmente!", type: .medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 50)
                    .frame(maxHeight: .infinity, alignment: .top)
                
            } else {
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach($viewModel.notifications) { $notification in
                            NavigationLink(destination: NotificationDetailView(notification: $notification, notifications: $viewModel.notifications)) {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Spacer()
                                                .frame(height: 4)
                                            
                                            Texts(text: notification.titulo, type: .mediumbold)
                                            
                                            Texts(text: ReadableDate(date: notification.fechaCreacion))
                                                .opacity(0.5)
                                        }
                                        .foregroundStyle(Color("Beige"))
                                        
                                        Spacer()
                                        
                                        if notification.leido == 0 {
                                            VStack {
                                                Spacer()
                                                Spacer()
                                                    .frame(height: 2)
                                                RectangleButton(title: "¡ Sin ver !", action: {}, type: .smallBlue)
                                                    .allowsHitTesting(false)
                                                Spacer()
                                            }
                                        }
                                    }
                                    DividerLine()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}
