//
//  AuthService.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 12/11/25.
//

import Foundation

enum NetworkError: Error {
    case http(status: Int, data: Data?)
    case invalidData
    case urlError(Error)
}

struct LoginResponse: Codable {
    struct User: Codable {
        let id: String
        let username: String
        let role: String?


        enum CodingKeys: String, CodingKey {
            case id, username, role
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let intId = try? container.decode(String.self, forKey: .id) {
                id = intId
            } else if let strId = try? container.decode(String.self, forKey: .id) {
                let trimmed = strId.trimmingCharacters(in: .whitespacesAndNewlines)
                if let parsed = String?(trimmed) {
                    id = parsed
                } else if let doubleVal = Double(trimmed) {
                    // If backend sent a decimal like "123.0", accept it
                    id = String(doubleVal)
                } else {
                    throw DecodingError.typeMismatch(Int.self,
                                                     DecodingError.Context(codingPath: container.codingPath + [CodingKeys.id],
                                                                           debugDescription: "Expected id as Int or numeric String; got value: \(strId)"))
                }
            } else {
                // If neither works, throw a decoding error with context for better debugging
                throw DecodingError.typeMismatch(Int.self,
                                                 DecodingError.Context(codingPath: container.codingPath + [CodingKeys.id],
                                                                       debugDescription: "Expected id as Int or numeric String"))
            }

            username = try container.decode(String.self, forKey: .username)
            role = try container.decodeIfPresent(String.self, forKey: .role)
        }
    }

    let user: User
    let accessToken: String
    let refreshToken: String
}

struct RefreshResponse: Codable {
    let accessToken: String
}

final class AuthService {
    private let baseURL = URL(string: Api.base)!
    private let jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .useDefaultKeys
        return d
    }()

    init() {}

    func login(username: String, password: String) async throws -> LoginResponse {
        let url = baseURL.appendingPathComponent("/user/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["username": username, "password": password]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.invalidData
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidData }
            guard 200..<300 ~= http.statusCode else { throw NetworkError.http(status: http.statusCode, data: data) }

            // First attempt: standard decode
            do {
                let decoded = try jsonDecoder.decode(LoginResponse.self, from: data)
                return decoded
            } catch {
                // Log initial decoding error and raw body
                let bodyString = String(data: data, encoding: .utf8) ?? "<non-utf8 or empty>"
                print("AuthService.login - decoding error: \(error). response body: \n\(bodyString)")

                // Fallback: try to repair JSON if user.id is a string
                do {
                    if var top = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       var userObj = top["user"] as? [String: Any] {
                        if let idStr = userObj["id"] as? String {
                            let trimmed = idStr.trimmingCharacters(in: .whitespacesAndNewlines)
                            if let intVal = Int(trimmed) {
                                userObj["id"] = intVal
                            } else if let doubleVal = Double(trimmed) {
                                userObj["id"] = Int(doubleVal)
                            }
                            top["user"] = userObj
                            let repairedData = try JSONSerialization.data(withJSONObject: top, options: [])
                            let decoded2 = try jsonDecoder.decode(LoginResponse.self, from: repairedData)
                            print("AuthService.login - succeeded decoding after repair of user.id string -> int")
                            return decoded2
                        }
                    }
                } catch {
                    print("AuthService.login - fallback repair failed: \(error)")
                }

                // If we get here, decoding didn't work
                if error is DecodingError {
                    throw NetworkError.invalidData
                }
                throw NetworkError.urlError(error)
            }
        } catch let err as NetworkError {
            print("AuthService.login - network error: \(err)")
            throw err
        } catch {
            print("AuthService.login - unexpected error: \(error) | url: \(request.url?.absoluteString ?? "nil")")
            throw NetworkError.urlError(error)
        }
    }

    /// POST /user/refresh
    func refresh(refreshToken: String) async throws -> RefreshResponse {
        let url = baseURL.appendingPathComponent("/user/refresh")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["refreshToken": refreshToken]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.invalidData
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidData }
            guard 200..<300 ~= http.statusCode else { throw NetworkError.http(status: http.statusCode, data: data) }

            do {
                let decoded = try jsonDecoder.decode(RefreshResponse.self, from: data)
                return decoded
            } catch {
                let bodyString = String(data: data, encoding: .utf8) ?? "<non-utf8 or empty>"
                print("AuthService.refresh - decoding error: \(error). response body: \n\(bodyString)")
                if error is DecodingError {
                    throw NetworkError.invalidData
                }
                throw NetworkError.urlError(error)
            }
        } catch let err as NetworkError {
            print("AuthService.refresh - network error: \(err)")
            throw err
        } catch {
            print("AuthService.refresh - unexpected error: \(error) | url: \(request.url?.absoluteString ?? "nil")")
            throw NetworkError.urlError(error)
        }
    }
}
