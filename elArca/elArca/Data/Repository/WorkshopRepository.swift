//
//  WorkshopRepository.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 04/11/25.
//

import Foundation

protocol WorkshopRepositoryProtocol {
    func getWorkshops() async -> [WorkshopResponse]?
    func getWorkshop(id: String) async -> WorkshopResponse?
    func clearStorage() async -> Void
}

final class WorkshopRepository: WorkshopRepositoryProtocol {
    static let shared = WorkshopRepository()

    private var storage: [WorkshopResponse] = []
    private var didLoadFromAPI = false

    init() {}

    // Ensures data is fetched from API only once per app run.
    // - Side effects: sets `didLoadFromAPI` and populates `storage`.
    private func ensureLoaded() async {
        guard !didLoadFromAPI else { return }
        didLoadFromAPI = true
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return
        }

        do {
            print("Fetching workshops from: \(baseURL.appendingPathComponent(Api.routes.workshops).absoluteString)")
            storage = try await WorkshopService.shared.getWorkshops(
                baseURL: baseURL,
                path: Api.routes.workshops
            )

            print("Successfully fetched and stored \(storage.count) workshops")
        } catch {
            print("Error al cargar talleres: \(error)")
            print("Error details: \(error.localizedDescription)")
        }
    }

    // Returns cached workshops; triggers a lazy load if needed.
    func getWorkshops() async -> [WorkshopResponse]? {
        await ensureLoaded()
        return storage
    }

    // Returns a single workshop by id. Tries cache first; on miss, fetches from API and caches the result.
    func getWorkshop(id: String) async -> WorkshopResponse? {
        if let found = storage.first(where: { $0.idTaller == id }) {
            return found
        }

        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return nil
        }

        do {
            let workshop = try await WorkshopService.shared.getWorkshop(baseURL: baseURL, path: Api.routes.workshops, id: id)
            storage.append(workshop)
            return workshop
        } catch {
            print("Error fetching workshop with id \(id): \(error)")
            return nil
        }
    }
    
    // Resets the loaded flag so the next `getWorkshops` call will fetch again from the API.
    func clearStorage() async {
        didLoadFromAPI = false
    }
}
