//
//  ContentView.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 20/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 50) {
            CircleButton(
                title: "+",
                action: { print("mas") },
            )
            
            RectangleButton(
                            title: "Generar QR",
                            action: { print("generar qr") },
                            type: .smallWhite
                        )
            RectangleButton(
                            title: "Ver",
                            action: { print("ver") },
                            type: .smallBlue
                        )
            RectangleButton(
                            title: "Eliminar",
                            action: { print("eliminar") },
                            type: .largeGray
                        )
            RectangleButton(
                            title: "Modificar",
                            action: { print("modificar") },
                            type: .largeBlue
                        )
            RectangleButton(
                            title: "Entregado",
                            action: { print("entregado") },
                            type: .mediumGray
                        )
            RectangleButton(
                            title: "Activo",
                            action: { print("activo") },
                            type: .mediumBlue
                        )
            RectangleButton(
                            title: "Caducado",
                            action: { print("caducado") },
                            type: .mediumRed
                        )
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    ContentView().preferredColorScheme(.dark)
}
