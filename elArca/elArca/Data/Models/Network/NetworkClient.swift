//
//  NetworkClient.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 12/11/25.
//

import Foundation


final class NetworkClient {
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
