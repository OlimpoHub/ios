import Foundation

protocol DiscapacityRepositoryProtocol {
    func getDiscapacities() async -> [DiscapacityResponse]?
    func getDiscapacity(id: String) async -> DiscapacityResponse?
}

final class DiscapacityRepository: DiscapacityRepositoryProtocol {
    static let shared = DiscapacityRepository()
    
    private var storage: [DiscapacityResponse] = []
    private var didLoadFromAPI = false
    
    private init() {}
    
    private func ensureLoaded() async {
        guard !didLoadFromAPI else { return }
        didLoadFromAPI = true
        
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return
        }
        
        do {
            print("Fetching discapacities from: \(baseURL.appendingPathComponent(Api.routes.discapacities).absoluteString)")
            
            storage = try await DiscapacityService.shared.getDiscapacities(
                baseURL: baseURL,
                path: Api.routes.discapacities
            )
            
            print("Successfully fetched and stored \(storage.count) discapacities")
        } catch {
            print("Error loading discapacities: \(error)")
        }
    }
    
    func getDiscapacities() async -> [DiscapacityResponse]? {
        await ensureLoaded()
        return storage
    }
    
    func getDiscapacity(id: String) async -> DiscapacityResponse? {
        if let found = storage.first(where: { $0.idDiscapacidad == id }) {
            return found
        }
        
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return nil
        }
        
        do {
            let discapacity = try await DiscapacityService.shared.getDiscapacity(
                baseURL: baseURL,
                path: Api.routes.discapacities,
                id: id
            )
            
            storage.append(discapacity)
            return discapacity
        } catch {
            print("Error fetching discapacidad with id \(id): \(error)")
            return nil
        }
    }
}
