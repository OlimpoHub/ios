//
//  BeneficiaryService.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 11/11/25.
//
import Foundation

final class BeneficiaryService {
    static let shared = BeneficiaryService()
    func getBeneficiaries(baseURL: URL, path: String) async throws -> [BeneficiaryResponse] {

        let url = baseURL.appendingPathComponent(path + "list")
        print("Requesting beneficiaries from \(url.absoluteString)")

        let (data, _) = try await URLSession.shared.data(from: url)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("✅ JSON recibido desde la API:\n\(jsonString)")
        }
        if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
           let message = errorResponse["message"] {
            throw NSError(domain: "", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: message])
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([BeneficiaryResponse].self, from: data)
    }

    func getBeneficiary(baseURL: URL, path: String, id: String) async throws -> BeneficiaryResponse {

        let url = baseURL.appendingPathComponent(path + id)
        print("Requesting beneficiary \(id) from \(url.absoluteString)")

        let (data, _) = try await URLSession.shared.data(from: url)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("✅ JSON recibido desde la API:\n\(jsonString)")
        }

        if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
           let message = errorResponse["message"] {
            throw NSError(domain: "", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: message])
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(BeneficiaryResponse.self, from: data)
    }
}
