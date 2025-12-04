import Foundation

final class DiscapacityService {
    static let shared = DiscapacityService()
    private init() {}

    func getDiscapacities(baseURL: URL, path: String) async throws -> [DiscapacityResponse] {
        print("DiscapacityService: fetching discapacities from \(baseURL.appendingPathComponent(path).absoluteString)")

        let decoder = JSONDecoder()

        // Build request and use NetworkClient interceptor
        let url = baseURL.appendingPathComponent(path)
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let (data, _) = try await NetworkClient.shared.request(req)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON recibido:\n\(jsonString)")
        }

        let discapacities = try decoder.decode([DiscapacityResponse].self, from: data)
        print("DiscapacityService: received \(discapacities.count) discapacities")
        return discapacities
    }

    func getDiscapacity(baseURL: URL, path: String, id: String) async throws -> DiscapacityResponse {
        let decoder = JSONDecoder()
        let fullPath = path + id
        print("DiscapacityService: fetching discapacity from \(baseURL.appendingPathComponent(fullPath).absoluteString)")

        // Build request and use NetworkClient interceptor
        let url = baseURL.appendingPathComponent(fullPath)
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let (data, _) = try await NetworkClient.shared.request(req)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON recibido:\n\(jsonString)")
        }

        struct Wrapper: Decodable {
            let discapacity: [DiscapacityResponse]
        }

        let wrapper = try decoder.decode(Wrapper.self, from: data)

        guard let first = wrapper.discapacity.first else {
            throw ApiError.decodingError(NSError(domain: "DiscapacityService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No discapacity found in response"]))
        }

        print("DiscapacityService: received discapacity \(first.idDiscapacidad)")
        return first
    }
}
