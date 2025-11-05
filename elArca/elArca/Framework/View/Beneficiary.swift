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
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    //titulo y campana
                    HStack(spacing: 8) {
                        Texts(text: "Beneficiarios", type: .header)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        IconButtonAtom(imageName: "notification") {
                            print("Notificación")
                        }
                    }
                    .padding(.horizontal)
                    
                    //search bar y filtrar
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
                    }.padding(.horizontal)
                    
                    //main
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 30),
                                GridItem(.flexible(), spacing: 30)
                            ],
                            spacing: 30
                        ) {
                            ForEach(0..<20, id: \.self) { index in
                                // navigationlink
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
                    }
                    Spacer()
                }
                //barra navegacion
                NavBar()
            }
            //para regresar
            .navigationDestination(item: $selectedBeneficiario) { index in
                BeneficiarioInfoCardsView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    Beneficiary().preferredColorScheme(.dark)
}
