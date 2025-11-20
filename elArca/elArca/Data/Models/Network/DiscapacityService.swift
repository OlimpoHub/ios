import Foundation

final class DiscapacityService {
    static let shared = DiscapacityService()
    private init() {}

    func getDiscapacities(baseURL: URL, path: String) async throws -> [DiscapacityResponse] {
        print("DiscapacityService: fetching discapacities from \(baseURL.appendingPathComponent(path).absoluteString)")

let decoder = JSONDecoder()
        
        let discapacities: [DiscapacityResponse] = try await NetworkAPIService.shared.fetch(baseURL: baseURL, path: path, decoder: decoder)
        print("DiscapacityService: received \(discapacities.count) discapacities")
        return discapacities
    }

    func getDiscapacity(baseURL: URL, path: String, id: String) async throws -> DiscapacityResponse {
        let decoder = JSONDecoder()
        let fullPath = path + id
        print("DiscapacityService: fetching discapacity from \(baseURL.appendingPathComponent(fullPath).absoluteString)")

        struct Wrapper: Decodable {
            let discapacity: [DiscapacityResponse]
        }

        let wrapper: Wrapper = try await NetworkAPIService.shared.fetch(baseURL: baseURL, path: fullPath, decoder: decoder)

        guard let first = wrapper.discapacity.first else {
            throw ApiError.decodingError(NSError(domain: "DiscapacityService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No discapacity found in response"]))
        }

        print("DiscapacityService: received discapacity \(first.idDiscapacidad)")
        return first
    }
}
