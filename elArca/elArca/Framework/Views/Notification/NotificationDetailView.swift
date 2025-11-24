//
//  NotificationDetailView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 17/11/25.
//

//
//  NotificationView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 05/11/25.
//

import SwiftUI
import Foundation

struct NotificationDetailView: View {
    @Binding var notification: NotificationInfo
    @Binding var notifications: [NotificationInfo]
    
    @StateObject var viewModel = NotificationDetailViewModel()
    
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                
                Texts(text: notification.titulo, type: .header)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    Texts(text: ReadableDate(date: notification.fechaCreacion))
                        .opacity(0.5)
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 24)
                
                Texts(text: notification.mensaje, type: .medium)
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .background(Color("Bg"))
        .navigationBarHidden(true)
        .onAppear() {
            if notification.leido == 0 {
                viewModel.readNotification(notification: notification.idNotificacionesUsuario)
                notification.leido = 1
                notifications.sort()
            }
        }
    }
}
