//
//  WorkshopView.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 04/11/25.
//

import SwiftUI

struct WorkshopView: View {
    
    @StateObject private var viewModel = WorkshopViewModel()
    
    var body: some View {
        VStack {
            NavigationView {
                ZStack {
                    VStack(spacing: 0) {
                        // Header with Title and Notification Bell (needs to update icons and add navbar)
                        HStack {
                            Texts(text: "Talleres", type: .header)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            NotificationButton()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        
                        // Contenido principal
                        mainContent
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarHidden(true)
            }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                    .frame(maxHeight: .infinity)
                
            } else if viewModel.workshops.isEmpty {
                // Estado Vacío
                let message = viewModel.searchText.isEmpty ?
                    "No hay talleres disponibles por el momento." :
                    "No se encontraron talleres para \"\(viewModel.searchText)\""
                

                Texts(text: message, type: .medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 50)
                    .frame(maxHeight: .infinity, alignment: .top)
                
            } else {
                // --- Estado de Éxito (Lista) ---
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        ForEach(viewModel.workshops) { workshop in
                            NavigationLink(destination: WorkshopDetailView(id: workshop.idTaller)) {
                                MenuButton(
                                    text: workshop.name,
                                    height: 110,
                                    buttonType: .gradient,
                                    image: .asset(workshop.imageName),
                                    screen: .none
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

#Preview {
    WorkshopView()
}

