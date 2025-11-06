//
//  NetworkAPIService.swift
//  elArca
//
//  Created by Fátima Figueroa on 05/11/25.
//

import Foundation
import Alamofire

enum ApiError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

struct Api {
    static let base = "http://10.102.201.23:8080/"
    struct routes {
        static let calendar = "calendar/"
        static let workshops = "workshop/"
    }
}

final class NetworkAPIService {
    static let shared = NetworkAPIService()
    private init() {}

    // Decodifier for date
    private static var decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .custom { decoder in
            let value = try decoder.singleValueContainer().decode(String.self)
            let fmt = ISO8601DateFormatter()
            fmt.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = fmt.date(from: value) {
                return date
            }
            // Fallback
            fmt.formatOptions = [.withInternetDateTime]
            if let date = fmt.date(from: value) {
                return date
            }
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "Fecha inválida: \(value)")
            )
        }
        return dec
    }()

    func getCalendarList(baseURL: URL, path: String = "calendar/", limit: Int? = nil) async throws -> [CalendarInfo] {
        var url = baseURL.appendingPathComponent(path)
        var params: Parameters = [:]
        if let limit { params["limit"] = limit }

        let request = AF.request(url, method: .get, parameters: params).validate()
        let response = await request.serializingData().response

        switch response.result {
        case .success(let data):
            if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON completo recibido desde la API:\n\(jsonString)")
                } else {
                    print("No se pudo convertir la respuesta a String (data.count = \(data.count))")
                }
            return try NetworkAPIService.decoder.decode([CalendarInfo].self, from: data)
        case .failure(let error):
            throw error
        }
    }
    
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
