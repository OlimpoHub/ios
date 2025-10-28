//
//  ContentView.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 20/10/25.
//

import SwiftUI

struct ContentView: View{
    @State private var isValid: Bool = true
    @State private var isValid1: Bool = true
    
    @State private var test: String = ""
    
    @State private var username: String = ""
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            TextInput(value: $username,
                  isValid: $isValid,
                  label: "Username",
                  placeholder: "Only 6 chars or more",
                  type: .textInput)
                      .onChange(of: username) {
                          isValid = username.count >= 6
                  }
            
            TextInput(value: $test,
                  isValid: $isValid1,
                  label: "Test Text",
                  placeholder: "Anything",
                  type: .emailInput)
        }
    }
    
    
    
}

#Preview {
    ContentView().preferredColorScheme(.dark)
}
