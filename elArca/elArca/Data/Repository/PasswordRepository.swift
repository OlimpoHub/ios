import Foundation

protocol PasswordRepositoryProtocol {
    func requestRecoveryEmail(email: String) async throws
    func verifyToken(token: String) async throws -> String
    func updatePassword(email: String, password: String) async throws
}

final class PasswordRepository: PasswordRepositoryProtocol {
    static let shared = PasswordRepository()
    private init() {}

    private let service = PasswordService.shared

    func requestRecoveryEmail(email: String) async throws {
        try await service.requestRecoveryEmail(email: email)
    }

    func verifyToken(token: String) async throws -> String {
        return try await service.verifyToken(token: token)
    }

    func updatePassword(email: String, password: String) async throws {
        try await service.updatePassword(email: email, password: password)
    }
}
