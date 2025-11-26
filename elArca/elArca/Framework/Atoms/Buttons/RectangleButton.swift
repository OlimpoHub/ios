//
//  RectangleButton.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 23/10/25.
//

import SwiftUI

enum ButtonType {
    // Botones pequeños
    case smallWhite
    case smallBlue
    // Botones medianos
    case mediumBlue
    case mediumRed
    case mediumGray
    // Botones grandes
    case largeBlue
    case largeGray
    case largeRed

    var fontSize: CGFloat {
        switch self {
        case .smallWhite, .smallBlue, .mediumBlue, .mediumRed, .mediumGray:
            return 14
        case .largeBlue, .largeGray, .largeRed:
            return 16
        }
    }

    var backgroundColor: Color {
        switch self {
        case .largeGray, .mediumGray:
            return Color("Grayy")
        case .smallBlue, .mediumBlue, .largeBlue:
            return Color("DarkBlue")
        case .mediumRed:
            return Color("DarkRed")
        case .smallWhite:
            return .white
        case .largeRed:
            return Color("HighlightRed")
        }
    }

    var textColor: Color {
        switch self {
        case .mediumGray, .largeGray, .smallWhite:
            return Color("DarkBlue")
        default:
            return .white
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .smallWhite, .smallBlue:
            return 12
        case .mediumBlue, .mediumRed, .mediumGray:
            return 16
        case .largeBlue, .largeGray, .largeRed:
            return 20
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .smallWhite, .smallBlue:
            return 6
        case .mediumBlue, .mediumRed, .mediumGray:
            return 8
        case .largeBlue, .largeGray, .largeRed:
            return 12
        }
    }
}

struct RectangleButton: View {
    var title: String
    var action: () -> Void
    var type: ButtonType = .mediumBlue

    var body: some View {
        Button(action: action) {
            Texts(text: title, type: .mediumbold, size: type.fontSize)
                .foregroundColor(type.textColor)
                .padding(.horizontal, type.horizontalPadding)
                .padding(.vertical, type.verticalPadding)
                .background(type.backgroundColor)
                .cornerRadius(8)            
        }
        .buttonStyle(.plain)
    }
}


