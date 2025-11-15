//
//  elArcaApp.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 20/10/25.
//

import SwiftUI
import FlowStacks

@main
struct elArcaApp: App {
    var body: some Scene {
        WindowGroup {
            AppBackground {
                CoordinatorView().preferredColorScheme(.dark)
            }
        }
    }
}
