//
//  IconButton.swift
//  elArca
//
//  Created by Carlos Martínez on 27/10/25.
//

import SwiftUI

struct IconButton: View {
    var iconName: String       // Bootstrap icon (image in Assets)
    var title: String
    var action: () -> Void

    // Customization
    var iconSize: CGFloat = 26
    var textSize: CGFloat = 12
    var iconColor: Color = Color.white
    var textColor: Color = Color.white
    var backgroundColor: Color = Color("Background")
    var spacing: CGFloat = 6

    var body: some View {
        Button(action: action) {
            VStack(spacing: spacing) {
                Image(iconName) // Loads Bootstrap icon from Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(iconColor)

                Text(title)
                    .font(.custom("Poppins-SemiBold", size: textSize))
                    .foregroundColor(textColor)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

