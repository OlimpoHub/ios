//
//  HomeView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 04/11/25.
//

import SwiftUI

struct HomeView: View {
    var userName: String = "Mundito"
    var notifications: NotificationType = .with
    var qrText: String = "Generar QR de Asistencia"
    var qrSize: CGFloat = hasBigScreen() ? 148 : 110

    var body: some View {
        VStack {
            // Welcome and config
            HStack {
                // Name
                VStack(alignment: .leading) {
                    Texts(text: "Bienvenido,", type: .medium)
                    Texts(text: userName, type: .header)
                }
                
                Spacer()
                
                HStack(spacing: 24) {
                    NotificationButton()
                    
                    SystemButton(icon: Image(systemName: "gear"), iconSize: 30) {
                        print("xd")
                    }
                }
            }
            
            Spacer()
                .frame(height: 32)
            
            MenuButton(text: qrText, height: qrSize, buttonType: .solid, image: .asset("QR"))
            
            Spacer()
                .frame(height: 32)
            
            HStack(){
                Texts(text: "Menú principal", type: .header)
                Spacer()
            }
            
            VStack {
                Spacer()
                
                MenuButton(text: "Usuarios", height: 110, buttonType: .gradient, image: .asset("Usuarios"))
                Spacer()
                
                MenuButton(text: "Capacitaciones", height: 110, buttonType: .gradient, image: .asset("Capacitaciones"))
                Spacer()
                
                MenuButton(text: "Análisis", height: 110, buttonType: .gradient, image: .asset("Analisis"))
                Spacer()
            }
            
        }
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden(true)
    }
}
