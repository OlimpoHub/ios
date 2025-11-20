//
//  CalendarService.swift
//  elArca
//
//  Created by Fátima Figueroa on 05/11/25.
//

import Foundation
import Alamofire

final class CalendarService {
    static let shared = CalendarService()
    private init() {}

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
            return try CalendarService.decoder.decode([CalendarInfo].self, from: data)
        case .failure(let error):
            throw error
        }
    }
}
