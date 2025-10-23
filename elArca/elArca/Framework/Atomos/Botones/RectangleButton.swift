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
    // Botones medianos (estatus)
    case mediumBlue
    case mediumRed
    case mediumGray
    // Botones grandes
    case largeBlue
    case largeGray

    var height: CGFloat {
        switch self {
        case .smallWhite, .smallBlue:
            return 32
        case .mediumRed, .mediumGray, .mediumBlue:
            return 24
        case .largeBlue, .largeGray:
            return 40
        }
    }

    var width: CGFloat {
        switch self {
        case .smallWhite, .smallBlue:
            return 88
        case .mediumRed, .mediumGray, .mediumBlue:
            return 95
        case .largeBlue, .largeGray:
            return 112
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .smallWhite, .smallBlue,.mediumRed, .mediumGray, .mediumBlue:
            return 14
        case .largeBlue, .largeGray:
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
        }
    }

    var textColor: Color {
        switch self {
        case .mediumGray, .largeGray:
            return Color("DarkBlue")
        case .smallWhite:
            return Color("DarkBlue")
        default:
            return .white
        }
    }
}

struct RectangleButton: View {
    var title: String
    var action: () -> Void
    var type: ButtonType = .mediumBlue
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Poppins-SemiBold", size: type.fontSize))
                .foregroundColor(type.textColor)
                .frame(width: type.width, height: type.height)
                .background(type.backgroundColor)
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

