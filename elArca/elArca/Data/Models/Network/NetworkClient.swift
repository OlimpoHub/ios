//
//  NetworkClient.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 12/11/25.
//

import Foundation


'final class NetworkClient {
    static let shared = NetworkClient()
    private init() {}

    private let tokenManager = TokenManager.shared

    func request(_ req: URLRequest) async throws -> (Data, HTTPURLResponse) {
        var request = req

        // Attach access token if available
        if let access = tokenManager.getAccess() {
            request.setValue("Bearer \(access)", forHTTPHeaderField: "Authorization")
        }

        print("NetworkClient.request -> url: \(request.url?.absoluteString ?? "nil") method: \(request.httpMethod ?? "?")")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidData }
            if http.statusCode == 401 {
                print("NetworkClient.request -> received 401 for url: \(request.url?.absoluteString ?? "nil"), attempting refresh")
                // Try refreshing access toke
                do {
                    let newAccess = try await tokenManager.refreshAccessIfNeeded()
                    // Retry exactly once with new token
                    var retryRequest = req
                    retryRequest.setValue("Bearer \(newAccess)", forHTTPHeaderField: "Authorization")
                    print("NetworkClient.request -> retrying url: \(retryRequest.url?.absoluteString ?? "nil") with refreshed token")
                    let (rdata, rresponse) = try await URLSession.shared.data(for: retryRequest)
                    guard let rhttp = rresponse as? HTTPURLResponse else { throw NetworkError.invalidData }
                    if rhttp.statusCode == 401 {
                        print("NetworkClient.request -> retry also returned 401 for url: \(retryRequest.url?.absoluteString ?? "nil")")
                        throw NetworkError.http(status: rhttp.statusCode, data: rdata)
                    }
                    if 200..<300 ~= rhttp.statusCode {
                        return (rdata, rhttp)
                    }
                    throw NetworkError.http(status: rhttp.statusCode, data: rdata)
                } catch let auth as AuthError {
                    // Refresh failed: TokenManager already cleared tokens and posted logout.
                    // Propagate AuthError so upper layers (UI) can react (navigate to login).
                    print("NetworkClient.request -> token refresh failed: \(auth)")
                    throw auth
                } catch let net as NetworkError {
                    // Propagate network errors from the retry
                    print("NetworkClient.request -> network error during retry: \(net)")
                    throw net
                } catch {
                    print("NetworkClient.request -> unexpected error during refresh/retry: \(error)")
                    throw NetworkError.urlError(error)
                }
            }

            if 200..<300 ~= http.statusCode {
                return (data, http)
            } else {
                print("NetworkClient.request -> http error status: \(http.statusCode) for url: \(request.url?.absoluteString ?? "nil")")
                throw NetworkError.http(status: http.statusCode, data: data)
            }
        } catch let auth as AuthError {
            // Propagate authentication-specific failures
            print("NetworkClient.request -> auth error: \(auth)")
            throw auth
        } catch let net as NetworkError {
            print("NetworkClient.request -> NetworkError: \(net)")
            throw net
        } catch {
            // Log lower level URLSession/network errors
            print("NetworkClient.request -> unexpected error: \(error) for url: \(request.url?.absoluteString ?? "nil")")
            throw NetworkError.urlError(error)
        }
    }
}

final class NetworkClient {
    static let shared = NetworkClient()
    private init() {}

    private let tokenManager = TokenManager.shared

    func request(_ req: URLRequest) async throws -> (Data, HTTPURLResponse) {
        var request = req

        // Add access token
        if let access = tokenManager.getAccess() {
            request.setValue("Bearer \(access)", forHTTPHeaderField: "Authorization")
        } else {
            print("No access token available (unauthenticated request)")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.invalidData
            }

            print("Response received — Status: \(http.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response body:\n\(responseString)")
            }

            // HANDLE 401
            if http.statusCode == 401 {
                print("401 Unauthorized — token likely expired")
                
                // Try refreshing access toke
                do {
                    let newAccess = try await tokenManager.refreshAccessIfNeeded()
                    print("Token refreshed. New access: \(newAccess)")

                    // Retry exactly once with new token
                    var retryRequest = req
                    retryRequest.setValue("Bearer \(newAccess)", forHTTPHeaderField: "Authorization")

                    let (retryData, retryResponse) = try await URLSession.shared.data(for: retryRequest)

                    guard let retryHttp = retryResponse as? HTTPURLResponse else {
                        print("Retry response invalid")
                        throw NetworkError.invalidData
                    }

                    print("Retry status: \(retryHttp.statusCode)")
                    if let retryBody = String(data: retryData, encoding: .utf8) {
                        print("Retry body:\n\(retryBody)")
                    }

                    if retryHttp.statusCode == 401 {
                        print("Retry also failed with 401. Refresh is invalid → forcing logout.")
                        throw NetworkError.http(status: retryHttp.statusCode, data: retryData)
                    }

                    print("Retry success")
                    return (retryData, retryHttp)

                } catch let auth as AuthError {
                    print("Refresh failed — AuthError: \(auth)")
                    throw auth
                } catch {
                    print("Unexpected error during refresh: \(error)")
                    throw NetworkError.urlError(error)
                }
            }

            // NORMAL SUCCESS
            if 200..<300 ~= http.statusCode {
                print("Request completed successfully")
                return (data, http)
            } else {
                print("HTTP error: \(http.statusCode)")
                throw NetworkError.http(status: http.statusCode, data: data)
            }

        } catch let auth as AuthError {
            print("AuthError caught in top-level: \(auth)")
            throw auth

        } catch let net as NetworkError {
            print("NetworkError caught in top-level: \(net)")
            throw net

        } catch {
            print("Unexpected networking error: \(error)")
            throw NetworkError.urlError(error)
        }
    }
}
