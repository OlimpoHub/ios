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
        
        if let limit {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "limit", value: "\(limit)")]
            url = components?.url ?? url
        }

        print("Requesting calendar list: \(url.absoluteString)")
        
        // IMPORTANT
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        // Interceptor
        let (data, _) = try await NetworkClient.shared.request(req)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON recibido:\n\(jsonString)")
        }

        return try CalendarService.decoder.decode([CalendarInfo].self, from: data)
    }
}
