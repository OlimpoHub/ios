//
//  LoginViewModel.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 02/11/25.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    
    @Published var userNameError: String = ""
    @Published var passwordError: String = ""
    
    @Published var loginError: String? = nil
    @Published var successMessage: String? = nil
    
    var onLoginSuccess: ((String) -> Void)?
    
    
    private let authRequirement: AuthenticationRequirementProtocol
    
    init(authRequirement: AuthenticationRequirementProtocol = AuthenticationRepository.shared) {
        self.authRequirement = authRequirement
    }
    
    func loginTapped() {
        userNameError = ""
        passwordError = ""
        loginError = nil
        successMessage = nil
        
        guard !userName.isEmpty else {
            userNameError = "El nombre de usuario no puede estar vacío."
            return
        }
        
        guard !password.isEmpty else {
            passwordError = "La contraseña no puede estar vacía."
            return
        }
        
        isLoading = true
        Task { [weak self] in
            guard let self = self else { return }
            do {
                // Use the repository/requirement to perform login
                let user = try await self.authRequirement.login(username: self.userName, password: self.password)
                let role = user.role ?? ""
                await MainActor.run {
                    self.isLoading = false
                    // Show a temporary green success message for visual confirmation during testing
                    //self.successMessage = "Inicio de sesión correcto"
                    // Clear it after a short delay so it doesn't persist forever
                    Task { @MainActor in
                        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                        self.successMessage = nil
                    }
                    self.onLoginSuccess?(role)
                }
            } catch let networkError as NetworkError {
                var message = "Ocurrió un error. Intenta más tarde."
                switch networkError {
                case .http(status: let status, _):
                    if status == 401 {
                        message = "Usuario o contraseña incorrectos."
                    } else {
                        message = "Error del servidor (\(status))."
                    }
                case .invalidData:
                    message = "Respuesta inválida del servidor."
                case .urlError(let err):
                    // Show a more specific message in DEBUG; otherwise keep a friendly text
                    #if DEBUG
                    message = "Error de red: \(err.localizedDescription)"
                    #else
                    message = "Error de red. Revisa tu conexión."
                    #endif
                }
                await MainActor.run {
                    self.loginError = message
                    self.isLoading = false
                }
            } catch let authErr as AuthError {
                let message: String
                switch authErr {
                case .refreshFailed:
                    message = "Sesión expirada. Intenta iniciar sesión nuevamente."
                }
                await MainActor.run {
                    self.loginError = message
                    self.isLoading = false
                }
            } catch {
                // Show raw localizedDescription in DEBUG to help debugging
                #if DEBUG
                let message = "Error al iniciar sesión: \(error.localizedDescription)"
                #else
                let message = "Error al iniciar sesión. Intenta más tarde."
                #endif
                await MainActor.run {
                    self.loginError = message
                    self.isLoading = false
                }
            }
        }
    }
    
    func forgotPasswordTapped() {
        print("Forgot PasswordTapped")
    }
    
    // Placeholder for the "activa tu cuenta" / first login action.
    func firstLoginTapped() {
        print("First login / activate account tapped")
    }
}
