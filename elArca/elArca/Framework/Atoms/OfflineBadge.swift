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
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "wifi.slash")
                    .font(.caption)
                Texts(text: "Modo Offline", type: .small)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(Color("Beige"))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color("DarkRed"))
            .cornerRadius(16)
            Spacer()
        }
        .background(Color("Bg"))
    }
}

#Preview {
    OfflineBadge()
}
