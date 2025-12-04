//
//  WorkshopService.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 05/11/25.
//

import Foundation

final class WorkshopService {
    static let shared = WorkshopService()
    private init() {}

    // Fetch multiple workshops (all of them)
    func getWorkshops(baseURL: URL, path: String) async throws -> [WorkshopResponse] {
        let url = baseURL.appendingPathComponent(path)
        print("WorkshopService: fetching workshops from \(url.absoluteString)")

        let decoder = JSONDecoder()

        // IMPORTANT
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        // Interceptor
        let (data, _) = try await NetworkClient.shared.request(req)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON recibido:\n\(jsonString)")
        }

        let workshops: [WorkshopResponse] = try decoder.decode([WorkshopResponse].self, from: data)
        print("WorkshopService: received \(workshops.count) workshops")
        return workshops
    }

    // Fetch a single workshop by id (idTaller)
    func getWorkshop(baseURL: URL, path: String, id: String) async throws -> WorkshopResponse {
        let decoder = JSONDecoder()
        let fullPath = path + id
        let url = baseURL.appendingPathComponent(fullPath)
        print("WorkshopService: fetching workshop from \(url.absoluteString)")

        // IMPORTANT
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        // Interceptor
        let (data, _) = try await NetworkClient.shared.request(req)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON recibido:\n\(jsonString)")
        }

        // Safely extract the `workshop` array from the response
        let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = jsonObj as? [String: Any], let workshopAny = dict["workshop"] else {
            throw ApiError.decodingError(NSError(domain: "WorkshopService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No workshop found in response"]))
        }

        let workshopData = try JSONSerialization.data(withJSONObject: workshopAny, options: [])
        let workshops = try decoder.decode([WorkshopResponse].self, from: workshopData)

        guard let first = workshops.first else {
            throw ApiError.decodingError(NSError(domain: "WorkshopService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No workshop found in response"]))
        }

        print("WorkshopService: received workshop \(first.idTaller)")
        return first
    }
}
