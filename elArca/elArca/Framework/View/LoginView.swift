//
//  LoginView.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 01/11/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        AppBackground {
            ZStack {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Image("logo-el-arca")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .padding(.vertical, 40)
                        
                        TextInput(
                            value: $viewModel.userName,
                            errorMessage: $viewModel.userNameError,
                            label: "Nombre",
                            placeholder: "E.G. John Smith",
                            type: .textInput
                        )
                        
                        TextInput(
                            value: $viewModel.password,
                            errorMessage: $viewModel.passwordError,
                            label: "Contraseña",
                            placeholder: "••••••••••",
                            type: .passwordInput
                        )
                        
                        Button(action: {
                            viewModel.forgotPasswordTapped()
                        }) {
                            Texts(text: "Recuperar Contraseña", type: .small)
                                .underline()
                                .foregroundColor(Color("Gray"))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 20)
                        
                        RectangleButton(
                            title: "Iniciar Sesión",
                            action: {
                                viewModel.loginTapped()
                            },
                            type: .largeBlue
                        )
                        .frame(maxWidth: .infinity)
                        
                        if let error = viewModel.loginError {
                            Texts(text: error, type: .small)
                                .foregroundColor(Color("HighlightRed"))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 10)
                        }
                        
                        Spacer()
                            .frame(height: 100)
                        
                    }
                    .padding(.horizontal, 30)
                    
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
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}
