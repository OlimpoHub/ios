//
//  NotificationService.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 17/11/25.
//

import Foundation
import Alamofire

final class NotificationService {
    static let shared = NotificationService()
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

    func fetchNotifications(baseURL: URL, path: String = "notifications/fetch", userId: String) async throws -> [NotificationInfo] {
        var url = baseURL.appendingPathComponent(path)
        var body: [String: Any] = [
            "userId": userId
        ]

        let request = AF.request(url, method: .get, parameters: body, encoding: JSONEncoding.default).validate()
        let response = await request.serializingData().response

        switch response.result {
        case .success(let data):
            if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON completo recibido desde la API:\n\(jsonString)")
                } else {
                    print("No se pudo convertir la respuesta a String (data.count = \(data.count))")
                }
            return try NotificationService.decoder.decode([NotificationInfo].self, from: data)
        case .failure(let error):
            throw error
        }
    }
    
    func fetchNewNotifications(baseURL: URL, path: String = "notifications/fetch/new", userId: String) async throws -> NotificationNewInfo {
        var url = baseURL.appendingPathComponent(path)
        var body: [String: Any] = [
            "userId": userId
        ]

        let request = AF.request(url, method: .get, parameters: body, encoding: JSONEncoding.default).validate()
        let response = await request.serializingData().response

        switch response.result {
        case .success(let data):
            if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON completo recibido desde la API:\n\(jsonString)")
                } else {
                    print("No se pudo convertir la respuesta a String (data.count = \(data.count))")
                }
            return try NotificationService.decoder.decode([NotificationNewInfo].self, from: data)[0]
        case .failure(let error):
            throw error
        }
    }
}
