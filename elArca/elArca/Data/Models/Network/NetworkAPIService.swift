//
//  NetworkAPIService.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 05/11/25.
//

import Foundation

enum ApiError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

final class NetworkAPIService {
    static let shared = NetworkAPIService()
    
    private init() {}
    
    func getWorkshops(baseURL: URL, path: String) async throws -> [WorkshopResponse] {
        let url = baseURL.appendingPathComponent(path)
        
        print("Requesting workshops from: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("HTTP Error - Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            throw ApiError.networkError(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }
        
        print("HTTP 200 OK - Received \(data.count) bytes")
        
        // Print raw JSON for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON response: \(jsonString)")
        }
        
        let decoder = JSONDecoder()
        do {
            let workshops = try decoder.decode([WorkshopResponse].self, from: data)
            print("Successfully decoded \(workshops.count) workshops")
            return workshops
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
