//
//  Untitled.swift
//  elArca
//
//  Created by user285809 on 12/1/25.
//

import SwiftUI

struct OfflineBadge: View {
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "wifi.slash")
                .font(.caption)
            Text("Modo Offline")
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.red)
        .cornerRadius(16)
    }
}

#Preview {
    OfflineBadge()
}
