//
//  ContentView.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 20/10/25.
//

import SwiftUI
import PhotosUI

// Lets the user hide the keyboard if pressing on the screen
// ... existing code ...
    func hideKeyboard() {
// ... existing code ...
    }

struct ContentView: View {
    
    
    var body: some View {
        // Mostramos la nueva pantalla de Talleres
        WorkshopView()
    }
}

#Preview {
    ContentView()
}
