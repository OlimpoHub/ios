//
//  ContentView.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 20/10/25.
//

import SwiftUI
import PhotosUI

// Lets the user hide the keyboard if pressing on the screen
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}

struct ContentView: View{
    /*@State private var fileValue: String = ""
    @State private var fileValid: String = ""
    
    @State private var userValue: String = ""
    @State private var userValid: String = ""
    
    @State private var passwordValue: String = ""
    @State private var passwordValid: String = ""
    
    @State private var descriptionValue: String = ""
    @State private var descriptionValid: String = ""
    
    @State private var descriptionValue1: String = ""
    @State private var descriptionValid2: String = ""
    
    @State private var selectValue: String = ""
    @State private var selectValid: String = ""
    
    @State private var calendarValue: Date = Date()
    @State private var calendarValid: String = ""
    @State private var calendarActive: Bool = false
    
    @State private var calendarValue1: Date = Date()
    @State private var calendarValid1: String = ""
    @State private var calendarActive1: Bool = false
    
    @State private var intValue: CGFloat = 0
    @State private var intValid: String = ""*/
    
    var body: some View {
        /*ScrollView {
            VStack(spacing: 0) {
                FileInput(
                    value: $fileValue,
                    errorMessage: $fileValid,
                    label: "Foto de perfil",
                    fileTypes: [.image],
                )
                
                TextInput(
                    value: $userValue,
                    errorMessage: $userValid,
                    label: "Correo electrónico",
                    placeholder: "example@here.com",
                    type: .emailInput
                )
                
                TextInput(
                    value: $passwordValue,
                    errorMessage: $passwordValid,
                    label: "Contraseña",
                    placeholder: "john123",
                    type: .passwordInput
                ).onChange(of: passwordValue) {
                    passwordValid = passwordValue.count >= 8 ? "" : "Contraseña muy pequeña"
                }
                
                TextInput(
                    value: $descriptionValue,
                    errorMessage: $descriptionValid,
                    label: "Descripción",
                    placeholder: "example@here.com",
                    type: .areaInput
                )
                
                TextInput(
                    value: $descriptionValue,
                    errorMessage: $descriptionValid,
                    label: "Búsqueda de persona",
                    placeholder: "Juanito Pérez",
                    type: .searchInput
                )
                
                TextInput(
                    value: $descriptionValue,
                    errorMessage: $descriptionValid,
                    label: "Búsqueda de persona",
                    placeholder: "Juanito Pérez",
                    type: .searchBarInput
                )
                
                TextInput(
                    value: $selectValue,
                    errorMessage: $selectValid,
                    label: "Persona 1",
                    placeholder: "Seleccionar aquí",
                    options: [("Juan", "1"), ("José", "2"), ("Javier", "3")],
                    type: .selectInput
                )
                
                // If using many inputs in a row, the .top is essential
                HStack(alignment: .top) {
                    DateInput(
                        value: $calendarValue,
                        errorMessage: $calendarValid,
                        isActive: $calendarActive,
                        label: "Fecha de inicio",
                    )
                    
                    DateInput(
                        value: $calendarValue1,
                        errorMessage: $calendarValid1,
                        isActive: $calendarActive1,
                        label: "Fecha de nacimiento",
                    )
                }
                
                NumberInput(
                    value: $intValue,
                    errorMessage: $intValid,
                    label: "Peso",
                    placeholder: "10 kg",
                    type: .float
                )
                
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }*/
        
        VStack {
            HomeView()
        }
    }
}

#Preview {
    AppBackground {
        ContentView().preferredColorScheme(.dark)
    }
}
