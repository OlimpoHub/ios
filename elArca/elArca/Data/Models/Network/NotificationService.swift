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

    // Obtains the user notifications
    func fetchNotifications(baseURL: URL, path: String = "notifications/fetch", userId: String) async throws -> [NotificationInfo] {
        var url = baseURL.appendingPathComponent(path)
                
        // Append query item userId
        if var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var items = comps.queryItems ?? []
            items.append(URLQueryItem(name: "userId", value: userId))
            comps.queryItems = items
            url = comps.url ?? url
        }

        print("Requesting notifications from \(url.absoluteString)")

        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let (data, _) = try await NetworkClient.shared.request(req)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON completo recibido desde la API:\n\(jsonString)")
        } else {
            print("No se pudo convertir la respuesta a String (data.count = \(data.count))")
        }

        return try NotificationService.decoder.decode([NotificationInfo].self, from: data)
    }
    
    // Obtains the amount of notifications the user hasn't seen
    func fetchNewNotifications(baseURL: URL, path: String = "notifications/fetch/new", userId: String) async throws -> NotificationNewInfo {
        var url = baseURL.appendingPathComponent(path)

        if var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var items = comps.queryItems ?? []
            items.append(URLQueryItem(name: "userId", value: userId))
            comps.queryItems = items
            url = comps.url ?? url
        }

        print("Requesting new notifications count from \(url.absoluteString)")

        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let (data, _) = try await NetworkClient.shared.request(req)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON completo recibido desde la API:\n\(jsonString)")
        } else {
            print("No se pudo convertir la respuesta a String (data.count = \(data.count))")
        }

        return try NotificationService.decoder.decode(NotificationNewInfo.self, from: data)
    }
    
    // Marks a notification as read
    func readNotification(baseURL: URL, path: String = "notifications/read", notificationId: String) async throws -> Void {
        let url = baseURL.appendingPathComponent(path)
        let body: [String: Any] = [
            "notificationId": notificationId
        ]

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        // Use NetworkClient to perform the request and handle auth/refresh
        _ = try await NetworkClient.shared.request(req)
    }
}
