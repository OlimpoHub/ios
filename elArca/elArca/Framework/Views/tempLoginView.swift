//
//  CoordinatorView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 04/11/25.
//

import FlowStacks
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var router: CoordinatorViewModel
    
    var body: some View {
        AppBackground {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(spacing: 20) {
                            Image("logo-el-arca")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .padding(.vertical, 10)

                            TextInput(
                                value: $viewModel.userName,
                                errorMessage: $viewModel.userNameError,
                                label: "Correo Electrónico",
                                placeholder: "E.G. ejemplo@correo.com",
                                type: .textInput
                            )
                            .frame(maxWidth: .infinity)

                            // Password input
                            TextInput(
                                value: $viewModel.password,
                                errorMessage: $viewModel.passwordError,
                                label: "Contraseña",
                                placeholder: "••••••••••",
                                type: .passwordInput
                            )
                            .frame(maxWidth: .infinity)

                            Button(action: {
                                viewModel.forgotPasswordTapped()
                            }) {
                                Texts(text: "Recuperar Contraseña", type: .small)
                                    .underline()
                                    .foregroundColor(Color("Beige"))
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 6)

                            // Login button
                            RectangleButton(
                                title: "Iniciar Sesión",
                                action: {
                                    viewModel.loginTapped()
                                },
                                type: .largeBlue
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)

                            // Error / Success messages
                            if let error = viewModel.loginError {
                                Texts(text: error, type: .small)
                                    .foregroundColor(Color("HighlightRed"))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 10)
                            }

                            if let success = viewModel.successMessage {
                                Texts(text: success, type: .small)
                                    .foregroundColor(.green)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 10)
                            }
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(Color(.secondarySystemBackground).opacity(0.03))
                        )
                        .padding(.top, 40)

                        Spacer()
                            .frame(height: 16)

                        // Bottom first-login / activate account link
                        HStack {
                            Spacer()
                            Texts(text: "Si es tu primer ingreso, ", type: .small)
                                .foregroundColor(Color("Beige"))
                            Button(action: {
                                viewModel.firstLoginTapped()
                            }) {
                                Texts(text: "activa tu cuenta", type: .small)
                                    .underline()
                                    .foregroundColor(Color.blue)
                            }
                            Spacer()
                        }
                        .padding(.top, 140)

                        Spacer()
                            .frame(height: 60)
                    }
                    .padding(.horizontal, 14)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }

                VStack {
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.onLoginSuccess = { role in
                KeychainHelper.shared.save(role, service: "com.elarca.auth", account: "userRole")

                Task { @MainActor in
                    router.changeView(newScreen: .home)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}
