//
//  RegularButton.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 04/11/25.
//

import SwiftUI

// 🔹 Átomo: Botón de ícono reutilizable
struct IconButtonAtom: View {
    var imageName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(8) // aumenta el área táctil
        }
        .buttonStyle(.plain) // evita el efecto azul por defecto
        .contentShape(Rectangle()) // ayuda a detectar el toque en toda el área con padding
        .accessibilityLabel(Text(imageName))
    }
}

