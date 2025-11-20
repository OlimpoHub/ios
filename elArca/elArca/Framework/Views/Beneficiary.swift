//
//  Beneficiario.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 01/11/25.
//

import SwiftUI

struct Beneficiary: View {
    @StateObject private var viewModel = BeneficiaryListViewModel()
    @State private var descriptionValue: String = ""
    @State private var descriptionValid: String = ""
    @State private var selectedBeneficiary: BeneficiaryResponse? = nil
    @State private var showRegister = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                
                if viewModel.isLoading {
                    ProgressView("Cargando beneficiarios...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text("❌ \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Header with Title and Notification Bell (needs to update icons and add navbar)
                        HStack {
                            Texts(text: "Beneficiarios", type: .header)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            NotificationButton()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // Search bar y filtro
                        HStack(spacing: 8) {
                            TextInput(
                                value: $descriptionValue,
                                errorMessage: $descriptionValid,
                                label: "",
                                placeholder: "Buscar",
                                type: .searchInput
                            )
                            IconButtonAtom(imageName: "filter") {
                                print("Filtro")
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
                                ForEach(viewModel.beneficiaries, id: \.idBeneficiario) { beneficiary in
                                    Button {
                                        selectedBeneficiary = beneficiary
                                    } label: {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Texts(text: "\(beneficiary.nombre) \(beneficiary.apellidoPaterno)", type: .medium)
                                                .font(.headline)
                                                .foregroundColor(.black)
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
                            .padding(.bottom, 80)
                        }
                    }
                }

                // Botón de agregar
               /* HStack {
                    Spacer()
                    CircleButton(title: "+") {
                        withAnimation {
                            showRegister = true
                        }
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 100)
                }*/
            }
            .background(Color("Bg"))
            
            // Navegación a detalles
            .navigationDestination(item: $selectedBeneficiary) { beneficiary in
                BeneficiarioInfoCardsView(beneficiary: beneficiary)
                    .navigationBarBackButtonHidden(true)
            }

            .sheet(isPresented: $showRegister) {
                BeneficiaryRegister()
                    .presentationDetents([.large])
            }
        }
    }
}

#Preview {
    Beneficiary().preferredColorScheme(.dark)
}
