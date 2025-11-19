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
        let path = comps.host ?? comps.path // handles elArcaApp://reset?token=.. (host=reset) or elArcaApp://reset
        let queryItems = comps.queryItems ?? []
        if let token = queryItems.first(where: { $0.name == "token" })?.value {
            let lower = path.lowercased()
            if lower.contains("reset") {
                DispatchQueue.main.async { self.activeRoute = .reset(token: token) }
                return
            }
            if lower.contains("activate") {
                DispatchQueue.main.async { self.activeRoute = .activate(token: token) }
                return
            }
            // this is the one that should open from the website link after we get the Domain for El Arca App
            if lower.contains("update") || lower.contains("update-password") {
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
