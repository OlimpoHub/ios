//
//  WorkshopRepository.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 04/11/25.
//

import Foundation

struct Api {
    static let base = "http://localhost:8080/"
    struct routes {
        static let workshops = "workshop/"
    }
}

protocol WorkshopRepositoryProtocol {
    func getWorkshops() async -> [WorkshopResponse]?
}

final class WorkshopRepository: WorkshopRepositoryProtocol {
    static let shared = WorkshopRepository()
    
    private var storage: [WorkshopResponse] = []
    private var didLoadFromAPI = false
    
    let nservice: NetworkAPIService
    
    init(nservice: NetworkAPIService = NetworkAPIService.shared) {
        self.nservice = nservice
    }
    
    private func ensureLoaded() async {
        guard !didLoadFromAPI else { return }
        didLoadFromAPI = true
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return
        }
        
        do {
            print("Fetching workshops from: \(baseURL.appendingPathComponent(Api.routes.workshops).absoluteString)")
            storage = try await nservice.getWorkshops(
                baseURL: baseURL,
                path: Api.routes.workshops
            )
            
            print("Successfully fetched and stored \(storage.count) workshops")
        } catch {
            print("Error al cargar talleres: \(error)")
            print("Error details: \(error.localizedDescription)")
        }
    }
    
    func getWorkshops() async -> [WorkshopResponse]? {
        await ensureLoaded()
        return storage
    }
}
