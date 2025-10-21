//
//  Boton.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 21/10/25.
//

import SwiftUI


struct GuardarButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 16)) // sizede texto
                .foregroundColor(.white) // color de texto
                .frame(width: 112, height: 40) // tamaño del botón
                .background(Color(red: 54/255, green: 85/255, blue: 199/255)) // color
                .cornerRadius(8)
        }
    }
}

#Preview {
    GuardarButton(title: "Guardar") {
    }
}
