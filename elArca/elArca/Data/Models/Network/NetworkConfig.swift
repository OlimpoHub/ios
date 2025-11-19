import Foundation

struct NetworkConfig {
    static var BASE_URL: String {
        return Api.base
    }

    static func verifyURL(token: String) -> URL? {
        guard let base = URL(string: BASE_URL) else { return nil }
        var comps = URLComponents(url: base.appendingPathComponent("user/verify-token"), resolvingAgainstBaseURL: false)
        comps?.queryItems = [URLQueryItem(name: "token", value: token)]
        return comps?.url
    }

    static func recoverPasswordURL() -> URL? {
        return URL(string: BASE_URL)?.appendingPathComponent("user/recover-password")
    }

    static func updatePasswordURL() -> URL? {
        return URL(string: BASE_URL)?.appendingPathComponent("user/update-password")
    }
}
