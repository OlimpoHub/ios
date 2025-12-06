//
//  BeneficiaryRepository.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 11/11/25.
//

// Repository for beneficiaries. Lazily loads from BeneficiaryService and caches in memory.
// - Also exposes filtering and category endpoints.

import Foundation

protocol BeneficiaryRepositoryProtocol {
    /// Returns all cached beneficiaries, loading from the API on first access.
    /// - Returns: an optional array of `BeneficiaryResponse` on success, or `nil` on failure.
    func getBeneficiaries() async -> [BeneficiaryResponse]?

    /// Returns a single beneficiary by id. If the beneficiary is cached it is returned immediately,
    /// otherwise the repository will fetch it from the service and append it to the cache.
    /// - Parameter id: beneficiary identifier
    /// - Returns: the matching `BeneficiaryResponse` or `nil` if not found or on error.
    func getBeneficiary(id: String) async -> BeneficiaryResponse?

    /// Resets any cached state so subsequent reads will re-fetch from the API.
    /// - Note: This does not delete remote data — it only affects in-memory caching.
    func clearStorage() async -> Void

    /// Fetches available filter categories used by the UI (e.g. disabilities, ordering options).
    /// - Returns: `BeneficiaryFilterCategories` on success, or `nil` on error.
    func getFilterCategories() async -> BeneficiaryFilterCategories?

    /// Sends a filter request to the service and returns the filtered beneficiaries.
    /// - Parameters:
    ///   - order: optional ordering string
    ///   - disabilities: list of disability identifiers to filter by
    /// - Returns: filtered list of `BeneficiaryResponse` or `nil` on error.
    func filterBeneficiaries(order: String?, disabilities: [String]) async -> [BeneficiaryResponse]?
}

class BeneficiaryRepository: BeneficiaryRepositoryProtocol {
    static let shared = BeneficiaryRepository()

    private var storage: [BeneficiaryResponse] = []
    private var didLoadFromAPI = false

    init() {}

    /// Ensures the repository has loaded beneficiaries from the API at least once.
    /// - Behavior: On the first call this will perform a network request to `BeneficiaryService` and
    ///   populate the in-memory `storage`. Subsequent calls return immediately.
    /// - Side effects: sets `didLoadFromAPI = true` and updates `storage`. Errors are logged.
    private func ensureLoaded() async {
        guard !didLoadFromAPI else { return }
        didLoadFromAPI = true
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return
        }

        do {
            print("Fetching beneficiary from: \(baseURL.appendingPathComponent(Api.routes.beneficiary).absoluteString)")
            storage = try await BeneficiaryService.shared.getBeneficiaries(
                baseURL: baseURL,
                path: Api.routes.beneficiary
            )
            print("✅ Successfully fetched and stored \(storage.count) beneficiaries")
            for b in storage {
                print("🧾 \(b.nombre) \(b.apellidoPaterno) - ID: \(b.idBeneficiario)")
            }
        } catch {
            print("❌ Error al cargar beneficiarios: \(error)")
            print("Error details: \(error.localizedDescription)")
        }

    }

    /// Returns all beneficiaries. Triggers a load from the API the first time it's called.
    /// - Returns: array of `BeneficiaryResponse` or `nil` if loading failed.
    func getBeneficiaries() async -> [BeneficiaryResponse]? {
        await ensureLoaded()
        return storage
    }

    /// Finds a beneficiary by id in the local cache or fetches it from the API if missing.
    /// - Parameter id: beneficiary identifier
    /// - Returns: the requested `BeneficiaryResponse` or `nil` if not found or on error.
    func getBeneficiary(id: String) async -> BeneficiaryResponse? {
        if let found = storage.first(where: { $0.idBeneficiario == id }) {
            return found
        }

        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return nil
        }

        do {
            let beneficiary = try await BeneficiaryService.shared.getBeneficiary(
                baseURL: baseURL,
                path: Api.routes.beneficiary,
                id: id
            )
            storage.append(beneficiary)
            return beneficiary
        } catch {
            print("Error fetching beneficiary with id \(id): \(error)")
            return nil
        }
    }
    
    /// Clears the in-memory cache so the next read will re-fetch from the API.
    /// - Note: This method is lightweight and only affects `didLoadFromAPI`.
    func clearStorage() async {
        didLoadFromAPI = false
        
        
    }
    
    /// Retrieves available filter categories from the backend service.
    /// - Returns: `BeneficiaryFilterCategories` on success, or `nil` on failure.
    func getFilterCategories() async -> BeneficiaryFilterCategories? {
            guard let baseURL = URL(string: Api.base) else {
                print("Error: Invalid base URL")
                return nil
            }

            do {
                let categories = try await BeneficiaryService.shared.getFilterCategories(
                    baseURL: baseURL,
                    path: Api.routes.beneficiary
                )
                return categories
            } catch {
                print("Error al obtener categorías de filtros: \(error)")
                return nil
            }
        }

    /// Sends a filter request to the service and returns matched beneficiaries.
    /// - Parameters:
    ///   - order: optional ordering rule
    ///   - disabilities: list of disability identifiers to filter by
    /// - Returns: array of matching `BeneficiaryResponse` or `nil` if the call fails.
    func filterBeneficiaries(order: String?, disabilities: [String]) async -> [BeneficiaryResponse]? {
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return nil
        }

        let body = BeneficiaryFilterBody(
            filters: .init(discapacidades: disabilities),
            order: order
        )

        do {
            let filtered = try await BeneficiaryService.shared.filterBeneficiaries(
                baseURL: baseURL,
                path: Api.routes.beneficiary,
                body: body
            )
            return filtered
        } catch {
            print("Error al filtrar beneficiarios: \(error)")
            return nil
        }
    }
}
