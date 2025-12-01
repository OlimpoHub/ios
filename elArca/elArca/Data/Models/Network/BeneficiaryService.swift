//
//  BeneficiaryService.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 11/11/25.
//
import Foundation
import Alamofire

class BeneficiaryService {
    static let shared = BeneficiaryService()
    
    // Decodifier for date
    private static var decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .custom { decoder in
            let value = try decoder.singleValueContainer().decode(String.self)
            let f = ISO8601DateFormatter()
            f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let d = f.date(from: value) { return d }
            f.formatOptions = [.withInternetDateTime]
            if let d = f.date(from: value) { return d }
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                                                    debugDescription: "Fecha inválida: \(value)"))
        }
        return dec
    }()
    
    func getBeneficiaries(baseURL: URL, path: String) async throws -> [BeneficiaryResponse] {
        let url = baseURL.appendingPathComponent(path + "list")
        print("Requesting beneficiaries from \(url.absoluteString)")

        // IMPORTANT: build URLRequest and go through NetworkClient interceptor
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let (data, _) = try await NetworkClient.shared.request(req)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON completo recibido desde la API:\n\(jsonString)")
        } else {
            print("No se pudo convertir la respuesta a String (data.count = \(data.count))")
        }

        return try BeneficiaryService.decoder.decode([BeneficiaryResponse].self, from: data)
    }

    func getBeneficiary(baseURL: URL, path: String, id: String) async throws -> BeneficiaryResponse {

        let url = baseURL.appendingPathComponent(path + id)
        print("Requesting beneficiary \(id) from \(url.absoluteString)")

        // IMPORTANT: build URLRequest and go through NetworkClient interceptor
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let (data, _) = try await NetworkClient.shared.request(req)

        if let jsonString = String(data: data, encoding: .utf8) {
            print(" JSON recibido desde la API:\n\(jsonString)")
        }

        // Check for an error message in the response
        if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
           let message = errorResponse["message"] {
            throw NSError(domain: "", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: message])
        }

        return try BeneficiaryService.decoder.decode(BeneficiaryResponse.self, from: data)
    }
    
    func getFilterCategories(baseURL: URL, path: String) async throws -> BeneficiaryFilterCategories {
        let url = baseURL.appendingPathComponent(path + "categories")
        print("Requesting beneficiary filter categories from \(url.absoluteString)")

        // Build GET request and use NetworkClient
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let (data, _) = try await NetworkClient.shared.request(req)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("Categorías recibidas:\n\(jsonString)")
        }

        let decoder = JSONDecoder()
        return try decoder.decode(BeneficiaryFilterCategories.self, from: data)
    }

    func filterBeneficiaries(
        baseURL: URL,
        path: String,
        body: BeneficiaryFilterBody
    ) async throws -> [BeneficiaryResponse] {

        let url = baseURL.appendingPathComponent(path + "filter")
        print("Requesting beneficiary filter to \(url.absoluteString)")

        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(body)

        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Body JSON que se envía:\n\(jsonString)")
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = jsonData

        let (data, _) = try await NetworkClient.shared.request(req)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("Beneficiarios filtrados:\n\(jsonString)")
        }
        return try BeneficiaryService.decoder.decode([BeneficiaryResponse].self, from: data)
    }
}
