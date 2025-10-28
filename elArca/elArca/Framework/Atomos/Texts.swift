//
//  Texts.swift
//  elArca
//
//  Created by Fátima Figueroa on 24/10/25.
//

import SwiftUI

enum TextType {
    case header
    case subtitle
    case small
    case medium
    case large
    
    var fontSize: CGFloat {
        switch self {
        case .header:
            return 24
        case .subtitle:
            return 20
        case .small:
            return 12
        case .medium:
            return 14
        case .large:
            return 16
        }
    }
    
    var thickness: String {
        switch self {
        case .header, .subtitle:
            return "Poppins-Bold"
        case .small, .medium, .large:
            return "Poppins-Regular"
        }
    }
    
    
}

struct Texts: View {
    var text: String
    var type: TextType = .medium
    
    var body: some View {
        Text(text)
            .font(.custom(type.thickness, size: type.fontSize))
            
    }
}

