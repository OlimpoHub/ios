//
//  NetworkAPIService.swift
//  elArca
//
//  Created by Fátima Figueroa on 05/11/25.
//

import Foundation
import Alamofire

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
}
