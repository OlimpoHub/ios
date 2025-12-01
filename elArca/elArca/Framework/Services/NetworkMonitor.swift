//
//  NetworkMonitor.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 30/11/25.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor: NWPathMonitor
    private let queue: DispatchQueue

    private var isConnected: Bool = false
    private var wasConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "com.yourapp.networkMonitor")

        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let newState = (path.status == .satisfied)

            self.isConnected = newState
            if self.isConnected != self.wasConnected {
                if self.isConnected {
                    // The internet is connected
                    
                } else {
                    // The internet is disconnected
                }
            }
            self.wasConnected = self.isConnected
        }

        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
