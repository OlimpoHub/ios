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
        NavigationView {
            ZStack {
                // Background Color
                Color("Background")
                    .ignoresSafeArea()
                
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
                
                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Add workshop action
                            print("Add workshop")
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(Color("HighlightBlue"))
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 75)
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
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
