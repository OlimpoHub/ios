//
//  NetworkAPIService.swift
//  elArca
//
//  Created by Fátima Figueroa on 05/11/25.
//
// Shared network service that provides a generic fetch method for Decodable types
// (If u need a different Decoder configuration for specific models, pass a custom JSONDecoder instance in your Service File)

import Foundation

public enum ApiError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse(statusCode: Int)
    case decodingError(Error)
}

public final class NetworkAPIService {
    public static let shared = NetworkAPIService()
    private init() {}

 
    public func fetch<T: Decodable>(baseURL: URL, path: String, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        let url = baseURL.appendingPathComponent(path)
        print("Requesting from: \(url.absoluteString)")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            print("Network request failed: \(error)")
            throw ApiError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            print("Response was not HTTPURLResponse: \(response)")
            throw ApiError.invalidResponse(statusCode: 0)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            print("HTTP Error - Status code: \(httpResponse.statusCode)")
            throw ApiError.invalidResponse(statusCode: httpResponse.statusCode)
        }

        print("HTTP \(httpResponse.statusCode) OK - Received \(data.count) bytes")
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON response: \(jsonString)")
        }

        do {
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            print("JSON Decoding Error: \(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Missing key: \(key.stringValue) - \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("Type mismatch for type: \(type) - \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("Value not found for type: \(type) - \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context.debugDescription)")
                @unknown default:
                    print("Unknown decoding error")
                }
            }
            throw ApiError.decodingError(error)
        }
    }
}
