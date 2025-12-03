import Foundation
import Combine
import SwiftUI

final class DeepLinkRouter: ObservableObject {
    enum Route: Equatable {
        case reset(token: String)
        case activate(token: String)
        case updatePassword(token: String)
    }

    @Published var activeRoute: Route? = nil

    func handle(_ url: URL) {
        #if DEBUG
        print("DeepLinkRouter.handle -> \(url.absoluteString)")
        #endif
        guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        // Build a normalized path string that includes host and path so we accept both
        // elArcaApp://update-password?token=...  (host = "update-password")
        // elArcaApp://user/update-password?token=... (host = "user", path = "/update-password")
        let hostPart = comps.host ?? ""
        let pathPart = comps.path // path contains leading slash if present
        let combined = (hostPart + pathPart).lowercased()

        let queryItems = comps.queryItems ?? []
        if let token = queryItems.first(where: { $0.name == "token" })?.value {
            if combined.contains("reset") {
                DispatchQueue.main.async { self.activeRoute = .reset(token: token) }
                return
            }
            if combined.contains("activate") {
                DispatchQueue.main.async { self.activeRoute = .activate(token: token) }
                return
            }
            // accept both update and update-password in any position
            if combined.contains("update") || combined.contains("update-password") {
                DispatchQueue.main.async { self.activeRoute = .updatePassword(token: token) }
                return
            }
        }
    }
}


// This is until we have a proper URL scheme registered (domain from El Arca App)
// Simulator test instructions (copy into terminal):
// xcrun simctl openurl booted 'elArcaApp://reset?token=EXAMPLE_TOKEN'
// xcrun simctl openurl booted 'elArcaApp://activate?token=EXAMPLE_TOKEN'
// xcrun simctl openurl booted 'elArcaApp://update-password?token=EXAMPLE_TOKEN'
// Also accepted: 'elArcaApp://user/update-password?token=EXAMPLE_TOKEN' or 'elArcaApp://user/update?token=EXAMPLE_TOKEN'
