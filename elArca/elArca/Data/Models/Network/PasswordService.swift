import Foundation

final class PasswordService {
    static let shared = PasswordService()
    private init() {}

    struct VerifyResponse: Codable {
        let valid: Bool
        let email: String?
    }

    enum PasswordError: Error {
        case invalidURL
        case network(Error)
        case http(status: Int, data: Data?)
        case invalidResponse
        case decoding(Error)
    }

    // POST /user/recover-password { "email": "..." }
    func requestRecoveryEmail(email: String) async throws {
        guard let base = URL(string: Api.base) else { throw PasswordError.invalidURL }
        guard let url = URL(string: "user/recover-password", relativeTo: base) else { throw PasswordError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email]
        req.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])


        do {
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse else { throw PasswordError.invalidResponse }
            guard (200...299).contains(http.statusCode) else { throw PasswordError.http(status: http.statusCode, data: data) }
            return
        } catch {
            throw PasswordError.network(error)
        }
    }

    // GET /user/verify-token?token=... -> { valid: Bool, email: String }
    func verifyToken(token: String) async throws -> String {
        guard let base = URL(string: Api.base) else { throw PasswordError.invalidURL }
        var comps = URLComponents(url: base.appendingPathComponent("user/verify-token"), resolvingAgainstBaseURL: false)
        comps?.queryItems = [URLQueryItem(name: "token", value: token)]
        guard let url = comps?.url else { throw PasswordError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"


        do {
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse else { throw PasswordError.invalidResponse }
            guard (200...299).contains(http.statusCode) else { throw PasswordError.http(status: http.statusCode, data: data) }
            do {
                let decoded = try JSONDecoder().decode(VerifyResponse.self, from: data)
                if decoded.valid, let email = decoded.email {
                    return email
                } else {
                    throw PasswordError.invalidResponse
                }
            } catch {
                throw PasswordError.decoding(error)
            }
        } catch {
            throw PasswordError.network(error)
        }
    }

    // POST /user/update-password { "email": "...", "password": "..." }
    func updatePassword(email: String, password: String) async throws {
        guard let base = URL(string: Api.base) else { throw PasswordError.invalidURL }
        guard let url = URL(string: "user/update-password", relativeTo: base) else { throw PasswordError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "password": password]
        req.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])


        do {
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse else { throw PasswordError.invalidResponse }
            guard (200...299).contains(http.statusCode) else { throw PasswordError.http(status: http.statusCode, data: data) }
            return
        } catch {
            throw PasswordError.network(error)
        }
    }
}
