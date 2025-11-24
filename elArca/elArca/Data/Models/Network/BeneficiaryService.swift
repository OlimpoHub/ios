//
//  BeneficiaryService.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 11/11/25.
//
import Foundation
import Alamofire

final class BeneficiaryService {
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

        let request = AF.request(url, method: .get).validate()
        let response = await request.serializingData().response

        switch response.result {
        case .success(let data):
            if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON completo recibido desde la API:\n\(jsonString)")
                } else {
                    print("No se pudo convertir la respuesta a String (data.count = \(data.count))")
                }
            return try BeneficiaryService.decoder.decode([BeneficiaryResponse].self, from: data)
        case .failure(let error):
            throw error
        }
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
