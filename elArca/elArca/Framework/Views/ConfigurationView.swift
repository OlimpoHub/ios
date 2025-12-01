//
//  ConfigurationView.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 23/11/25.
//

import SwiftUI

struct ConfigurationView: View {
    @EnvironmentObject var router: CoordinatorViewModel
    @EnvironmentObject var session: SessionStore
    
    @StateObject private var viewModel = AccesibilityViewModel()
    
    @State var dyslexicFontToggle: Bool = AccesibilityViewModel().dyslexicToggle
    @State var bigFontToggle: Bool = AccesibilityViewModel().biggerFontToggle
    @State var popup: Bool = false

    // Read from UserDefaults/Keychain
    private var userId: String { KeychainHelper.shared.currentUserIdFromDefaults() ?? "-" }
    private var userName: String { KeychainHelper.shared.currentUserNameFromDefaults() ?? "-" }
    private var role: String { session.userRole ?? KeychainHelper.shared.read(service: "com.elarca.auth", account: "userRole") ?? "-" }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 16) {
                Button(action: {
                    router.changeView(newScreen: .home)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }

                Texts(text: "Configuración", type: .header)
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.top, 20)
            
            // Accessibility Menu
            VStack(alignment: .leading, spacing: 8) {
                Texts(text: "Accesibilidad:", type: .largebold)
                
                Spacer()
                    .frame(height: 8)
                
                VStack {
                    HStack {
                        Toggle(isOn: $dyslexicFontToggle) {
                            Texts(text: "Fuente para dislexia:", type: .largebold)
                        }
                        .tint(Color("HighlightBlue"))
                        .onChange(of: dyslexicFontToggle) {
                            viewModel.setDyslexicToggle(value: dyslexicFontToggle)
                            popup = true
                        }
                    }
                    DividerLine()
                }
                
                VStack {
                    HStack {
                        Toggle(isOn: $bigFontToggle) {
                            Texts(text: "Tamaño de letra grande:", type: .largebold)
                        }
                        .tint(Color("HighlightBlue"))
                        .onChange(of: bigFontToggle) {
                            viewModel.setBiggerFontToggle(value: bigFontToggle)
                            popup = true
                        }
                    }
                    DividerLine()
                }
            }
            .alert("Para que todos los cambios tengan efecto regresa a la página anterior.", isPresented: $popup) {
                Button("OK", role: .cancel) {
                    popup = false
                }
            }

            // User data
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                Texts(text: "Datos de la sesión:", type: .largebold)
                    .padding(.bottom, 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Texts(text: "Nombre: ", type: .mediumbold)
                    Texts(text: userName, type: .medium)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Texts(text: "Rol: ", type: .mediumbold)
                    Texts(text: role, type: .medium)
                }
            }
            
            // Log out button
            HStack {
                Spacer()
                RectangleButton(title: "Cerrar sesión", type: .largeRed) {
                    SessionStore.shared.clearSession()
                    router.changeView(newScreen: .login)
                }
                Spacer()
            }
            .padding(.bottom, 24)

        }
        .padding(.horizontal, 24)
    }
}
