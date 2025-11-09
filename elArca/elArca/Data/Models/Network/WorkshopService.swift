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

    func getWorkshops(baseURL: URL, path: String) async throws -> [WorkshopResponse] {
        print("WorkshopService: fetching workshops from \(baseURL.appendingPathComponent(path).absoluteString)")

        let decoder = JSONDecoder()
        
        let workshops: [WorkshopResponse] = try await NetworkAPIService.shared.fetch(baseURL: baseURL, path: path, decoder: decoder)
        print("WorkshopService: received \(workshops.count) workshops")
        return workshops
    }
}
