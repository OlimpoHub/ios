//
//  ContentView.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 20/10/25.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}


struct ContentView: View{
    @State private var userValue: String = ""
    @State private var userValid: Bool = true
    
    @State private var passwordValue: String = ""
    @State private var passwordValid: Bool = true
    
    @State private var descriptionValue: String = ""
    @State private var descriptionValid: Bool = true
    
    @State private var descriptionValue1: String = ""
    @State private var descriptionValid2: Bool = true
    
    @State private var selectValue: String = ""
    @State private var selectValid: Bool = true
    
    @State private var calendarValue: Date = Date()
    @State private var calendarValid: Bool = true
    @State private var calendarActive: Bool = false
    
    @State private var intValue: CGFloat = 0
    @State private var intValid: Bool = true
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                TextInput(
                    value: $userValue,
                    isValid: $userValid,
                    label: "Correo electrónico",
                    placeholder: "example@here.com",
                    type: .emailInput
                )
                
                TextInput(
                    value: $passwordValue,
                    isValid: $passwordValid,
                    label: "Contraseña",
                    placeholder: "john123",
                    type: .passwordInput
                ).onChange(of: passwordValue) {
                    passwordValid = passwordValue.count >= 8
                }
                
                TextInput(
                    value: $descriptionValue,
                    isValid: $descriptionValid,
                    label: "Descripción",
                    placeholder: "example@here.com",
                    type: .areaInput
                )
                
                TextInput(
                    value: $descriptionValue,
                    isValid: $descriptionValid,
                    label: "Busqueda de persona",
                    placeholder: "Juanito Pérez",
                    type: .searchInput
                )
                
                TextInput(
                    value: $descriptionValue,
                    isValid: $descriptionValid,
                    label: "Busqueda de persona",
                    placeholder: "Juanito Pérez",
                    type: .searchBarInput
                )
                
                TextInput(
                    value: $selectValue,
                    isValid: $selectValid,
                    label: "Persona 1",
                    placeholder: "Seleccionar aquí",
                    options: [("Juanma", "1"), ("Pepe", "2"), ("XD", "3")],
                    type: .selectInput
                )
                
                HStack {
                    DateInput(
                        value: $calendarValue,
                        isValid: $calendarValid,
                        isActive: $calendarActive,
                        label: "Fecha de inicio",
                    )
                    
                    DateInput(
                        value: $calendarValue,
                        isValid: $calendarValid,
                        isActive: $calendarActive,
                        label: "Fecha de nacimiento",
                    )
                }
                
                NumberInput(
                    value: $intValue,
                    isValid: $intValid,
                    label: "Peso",
                    placeholder: "10 kg",
                    type: .float
                ).onChange(of: passwordValue) {
                    passwordValid = passwordValue.count >= 8
                }
                
                
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    ContentView().preferredColorScheme(.dark)
}
