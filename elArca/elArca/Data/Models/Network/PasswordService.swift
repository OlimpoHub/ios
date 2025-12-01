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
            // Use NetworkClient so the request goes through the interceptor
            let (_, http) = try await NetworkClient.shared.request(req)
            // NetworkClient returns only on 2xx; otherwise it throws NetworkError.http
            // If it succeeded, just return
            _ = http
            return
        } catch let net as NetworkError {
            // Map network http errors to PasswordError.http
            switch net {
            case .http(let status, let data):
                throw PasswordError.http(status: status, data: data)
            default:
                throw PasswordError.network(net)
            }
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
            let (data, http) = try await NetworkClient.shared.request(req)
            // Decode
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
        } catch let net as NetworkError {
            switch net {
            case .http(let status, let data):
                throw PasswordError.http(status: status, data: data)
            default:
                throw PasswordError.network(net)
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
            let (_, _) = try await NetworkClient.shared.request(req)
            return
        } catch let net as NetworkError {
            switch net {
            case .http(let status, let data):
                throw PasswordError.http(status: status, data: data)
            default:
                throw PasswordError.network(net)
            }
        } catch {
            throw PasswordError.network(error)
        }
    }
}
