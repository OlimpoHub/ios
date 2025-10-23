//
//  Boton.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 21/10/25.
//

import SwiftUI

enum ButtonType {
    //los de status
    case smallWhite
    case smallBlue
    //botones pequenos
    case mediumBlue
    case mediumRed
    case mediumGray
    //los mas grandes(eliminar, modificar)
    case largeGray
    case largeBlue

    var height: CGFloat {
        switch self {
        case .smallWhite, .smallBlue: return 32
        case .mediumRed,.mediumGray, .mediumBlue: return 24
        case .largeGray, .largeBlue: return 40
        }
    }
    var width: CGFloat {
        switch self {
        case .smallWhite, .smallBlue: return 88
        case .mediumRed,.mediumGray, .mediumBlue: return 95
        case .largeGray, .largeBlue: return 112
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .smallWhite, .smallBlue: return 14
        case .mediumRed,.mediumGray, .mediumBlue,.largeGray, .largeBlue: return 16
        }
    }

    var backgroundColor: Color {
        switch self {
        case .largeGray, .mediumGray: return Color("Grayy")
        case .smallBlue, .mediumBlue, .largeBlue: return Color("DarkBlue")
        case .mediumRed: return Color("DarkRed")
        case .smallWhite: return .white
        }
    }

    var textColor: Color {
        switch self {
        case .mediumGray, .largeGray, .smallWhite: return Color("DarkBlue")
        default: return .white
        }
    }
}


struct RectangleButton: View {
    var title: String
    var action: () -> Void
    var type: ButtonType = .mediumGray
    
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

