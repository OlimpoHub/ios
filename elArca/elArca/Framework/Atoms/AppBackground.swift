//
//  AppBackground.swift
//  elArca
//
//  Created by Fátima Figueroa on 27/10/25.
//

import SwiftUI

struct AppBackground<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            content()
        }
    }
}
