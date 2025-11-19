import Foundation
import Combine

final class ResetPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var emailError: String = ""
    @Published var infoMessage: String? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    // Token verification state
    @Published var showingVerifyState: Bool = false
    @Published var isTokenVerified: Bool = false
    private var verifiedEmail: String? = nil

    // Password fields
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    private let requirement: PasswordRequirementProtocol

    init(requirement: PasswordRequirementProtocol = PasswordRequirement.shared) {
        self.requirement = requirement
    }

    func requestRecoveryEmail(completion: @escaping (Result<Void, Error>) -> Void) {
        emailError = ""
        errorMessage = nil
        infoMessage = nil
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            emailError = "Ingresa un correo válido."
            return
        }
        isLoading = true
        Task {
            do {
                try await requirement.requestRecoveryEmail(email: email)
                await MainActor.run {
                    self.isLoading = false
                    self.infoMessage = "Si existe una cuenta con ese correo, se envió un email con instrucciones."
                    completion(.success(()))
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }

    func verifyToken(token: String) {
        showingVerifyState = true
        isLoading = true
        errorMessage = nil
        infoMessage = nil
        Task {
            do {
                let email = try await requirement.verifyToken(token: token)
                await MainActor.run {
                    self.isLoading = false
                    self.isTokenVerified = true
                    self.verifiedEmail = email
                    self.email = email
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Token inválido o expirado. Pide un nuevo correo de recuperación."
                    self.isTokenVerified = false
                }
            }
        }
    }

    func updatePassword(completion: @escaping (Result<Void, Error>) -> Void) {
        errorMessage = nil
        guard password.count >= 8 else {
            errorMessage = "La contraseña debe tener al menos 8 caracteres."
            completion(.failure(NSError(domain: "validation", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage ?? ""])))
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Las contraseñas no coinciden."
            completion(.failure(NSError(domain: "validation", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage ?? ""])))
            return
        }
        guard let emailToUpdate = verifiedEmail ?? (email.isEmpty ? nil : email) else {
            errorMessage = "Email inválido."
            completion(.failure(NSError(domain: "validation", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage ?? ""])))
            return
        }
        isLoading = true
        Task {
            do {
                try await requirement.updatePassword(email: emailToUpdate, password: password)
                await MainActor.run {
                    self.isLoading = false
                    self.infoMessage = "Contraseña actualizada correctamente."
                    completion(.success(()))
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
}
