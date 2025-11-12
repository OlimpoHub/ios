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
        print("WorkshopService: fetching workshops from \(baseURL.appendingPathComponent(path).absoluteString)")

        let decoder = JSONDecoder()
        
        let workshops: [WorkshopResponse] = try await NetworkAPIService.shared.fetch(baseURL: baseURL, path: path, decoder: decoder)
        print("WorkshopService: received \(workshops.count) workshops")
        return workshops
    }

    // Fetch a single workshop by id (idTaller)
    func getWorkshop(baseURL: URL, path: String, id: String) async throws -> WorkshopResponse {
        let decoder = JSONDecoder()
        let fullPath = path + id
        print("WorkshopService: fetching workshop from \(baseURL.appendingPathComponent(fullPath).absoluteString)")

        struct Wrapper: Decodable {
            let workshop: [WorkshopResponse]
            let beneficiaries: [AnyCodable]?
        }

        let wrapper: Wrapper = try await NetworkAPIService.shared.fetch(baseURL: baseURL, path: fullPath, decoder: decoder)

        guard let first = wrapper.workshop.first else {
            throw ApiError.decodingError(NSError(domain: "WorkshopService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No workshop found in response"]))
        }

        print("WorkshopService: received workshop \(first.idTaller)")
        return first
    }
}

struct AnyCodable: Codable {}
