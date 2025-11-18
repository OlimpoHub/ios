//
//  DividerLine.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 18/11/25.
//

import SwiftUI

struct DividerLine: View {
    var body: some View {
        Divider()
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .background(Color("Beige").opacity(0.20))
    }
}
