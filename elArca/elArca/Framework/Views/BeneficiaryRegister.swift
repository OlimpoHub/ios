//
//  BeneficiaryRegister.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 04/11/25.
//

import SwiftUI

struct BeneficiaryRegister: View {
    @Environment(\.dismiss) var dismiss
    @State private var descriptionValue: String = ""
    @State private var descriptionValid: String = ""
    
    @State private var selectValue: String = ""
    @State private var selectValid: String = ""
    
    @State private var calendarValue: Date = Date()
    @State private var calendarValid: String = ""
    @State private var calendarActive: Bool = false
    
    @State private var calendarValue1: Date = Date()
    @State private var calendarValid1: String = ""
    @State private var calendarActive1: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 8) {
                //titulo y return
                Texts(text: "Registrar Beneficiario", type: .header)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                //Dos columnas d etexto
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 150, height: 150)
                            .cornerRadius(16)
                            .shadow(radius: 4)
                        DateInput(
                            value: $calendarValue1,
                            errorMessage: $calendarValid1,
                            isActive: $calendarActive1,
                            label: "Fecha de nacimiento",
                        )
                        DateInput(
                            value: $calendarValue,
                            errorMessage: $calendarValid,
                            isActive: $calendarActive,
                            label: "Fecha de ingreso",
                        )
                        TextInput(
                            value: $selectValue,
                            errorMessage: $selectValid,
                            label: "Estatus",
                            placeholder: "Seleccionar",
                            options: [("Juan", "1"), ("José", "2"), ("Javier", "3")],
                            type: .selectInput
                        )
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextInput(
                            value: $selectValue,
                            errorMessage: $selectValid,
                            label: "Nombre beneficiario",
                            placeholder: "Escribe aquí",
                            type: .textInput )
                        TextInput(
                            value: $selectValue,
                            errorMessage: $selectValid,
                            label: "Nombre del tutor",
                            placeholder: "Escribe aquí",
                            type: .textInput )
                        TextInput(
                            value: $selectValue,
                            errorMessage: $selectValid,
                            label: "Relacion del tutor",
                            placeholder: "Escribe aquí",
                            type: .textInput )
                        TextInput(
                            value: $selectValue,
                            errorMessage: $selectValid,
                            label: "Numero de telefono",
                            placeholder: "Escribe aquí",
                            type: .textInput )
                        TextInput(
                            value: $selectValue,
                            errorMessage: $selectValid,
                            label: "Discapacidades",
                            placeholder: "Seleccionar",
                            options: [("Juan", "1"), ("José", "2"), ("Javier", "3")],
                            type: .selectInput
                        )

                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                VStack(alignment: .leading,spacing: 8) {
                    TextInput(
                        value: $descriptionValue,
                        errorMessage: $descriptionValid,
                        label: "Descripción",
                        placeholder: "example@here.com",
                        type: .areaInput
                    )
                }.padding(.horizontal).padding(.vertical)
                HStack(spacing: 16){
                    RectangleButton(title: "Cancelar", action: {
                        dismiss()
                    }, type: .mediumGray)
                    RectangleButton(title: "Guardar", action: {
                                        print("guardado")
                                    }, type: .mediumBlue)
                }.padding(.horizontal)
                
                Spacer()
            }
                        
        }
    }
}

#Preview {
    BeneficiaryRegister().preferredColorScheme(.dark)
}
