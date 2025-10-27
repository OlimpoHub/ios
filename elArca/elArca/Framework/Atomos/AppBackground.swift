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
            Color("Background")     // tu Color Set en Assets
                .ignoresSafeArea()          // cubre toda la pantalla
            content()
                .foregroundColor(Color("TextColor"))
        }
    }
}
