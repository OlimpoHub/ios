//
//  LoginViewModel.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 02/11/25.
//

import Foundation
internal import Combine

class LoginViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var password: String = ""
    
    @Published var userNameError: String = ""
    @Published var passwordError: String = ""
    
    @Published var loginError: String? = nil
    
    init() {
    }
    
    
    func loginTapped() {
        userNameError = ""
        passwordError = ""
        loginError = nil
        
        guard !userName.isEmpty else {
            userNameError = "El nombre de usuario no puede estar vacío."
            return
        }
        
        guard !password.isEmpty else {
            passwordError = "La contraseña no puede estar vacía."
            return
        }
        
        // El siguiente paso será
        // llamar al 'LoginUseCase', que a su vez llamará
        print("Login Tapped: \(userName), \(password)")
    }
    
    func forgotPasswordTapped() {
        print("Forgot PasswordTapped")
    }
}
