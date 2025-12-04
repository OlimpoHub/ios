//
//  CircleButton.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 23/10/25.
//

import SwiftUI

struct CircleButton: View {
    var title: String
    var action: () -> Void
    // El icono de circulo blanco de agregar
    var fontSize: CGFloat = 40
    var textColor: Color = Color("DarkBlue")
    var backgroundColor: Color = .white
    var horizontalPadding: CGFloat = 15
    var verticalPadding: CGFloat = 15
        
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Poppins-SemiBold", size: fontSize))
                .foregroundColor(textColor)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(backgroundColor)
                .clipShape(Circle())
                .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}


