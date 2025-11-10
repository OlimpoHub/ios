//
//  Beneficiario.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 01/11/25.
//

import SwiftUI

struct Beneficiary: View {
    @State private var descriptionValue: String = ""
    @State private var descriptionValid: String = ""
    @State private var selectedBeneficiario: Int? = nil
    @State private var showRegister = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Título y campana
                    HStack(spacing: 8) {
                        Texts(text: "Beneficiarios", type: .header)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        IconButtonAtom(imageName: "notification") {
                            print("Notificación")
                        }
                    }
                    .padding(.horizontal)
                    
                    // Search bar y filtro
                    HStack(spacing: 8){
                        TextInput(
                            value: $descriptionValue,
                            errorMessage: $descriptionValid,
                            label: "",
                            placeholder: "Buscar",
                            type: .searchInput
                        )
                        IconButtonAtom(imageName: "filter") {
                            print("filtro")
                        }
                    }
                    .padding(.horizontal)
                    
                    // Contenido principal con Scroll
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 30),
                                GridItem(.flexible(), spacing: 30)
                            ],
                            spacing: 30
                        ) {
                            ForEach(0..<20, id: \.self) { index in
                                Button {
                                    selectedBeneficiario = index
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text("Beneficiario \(index + 1)")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text("Detalles del beneficiario")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, minHeight: 180)
                                    .background(Color.white)
                                    .cornerRadius(24)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 80) // para el boton
                    }
                }
                
                // Boton de mas
                HStack {
                    Spacer()
                    CircleButton(title: "+") {
                    withAnimation {
                    showRegister = true }}
                    .padding(.trailing, 24)
                    .padding(.bottom, 100)
                }
                
            }
            
            // Navegación a detalles
            .navigationDestination(item: $selectedBeneficiario) { index in
                BeneficiarioInfoCardsView()
                    .navigationBarBackButtonHidden(true)
            }

           .sheet(isPresented: $showRegister) {
            BeneficiaryRegister()
                   .presentationDetents([.large])}
        }
    }
}

#Preview {
    Beneficiary().preferredColorScheme(.dark)
}
