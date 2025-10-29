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
            Texts (
                text: "Header 24",
                type: .header
            )
            Texts (
                text: "Subtitle 20",
                type: .subtitle
            )
            Texts (
                text: "Small 12",
                type: .small
            )
            Texts (
                text: "Medium 14",
                type: .medium
            )
            Texts (
                text: "Large 16",
                type: .large
            )
            RectangleButton(
                            title: "Activo",
                            action: {
                                print("boton")
                            },
                            type: .mediumBlue
                        )
            RectangleButton(
                            title: "Confirmar",
                            action: {
                                print("boton")
                            },
                            type: .largeBlue
                        )
            RectangleButton(
                            title: "Confirmar",
                            action: {
                                print("boton")
                            },
                            type: .smallBlue
                        )
            CircleButton(
                            title: "+",
                            action: {
                                print("boton")
                            }
                        )
        }
    }
}

#Preview {
    ContentView().preferredColorScheme(.dark)
}
