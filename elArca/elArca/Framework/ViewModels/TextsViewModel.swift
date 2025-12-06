//
//  TextsViewModel.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 26/11/25.
//

import Foundation
import Combine

class TextsViewModel: ObservableObject {
    @Published var font: String
    @Published var fontScale: CGFloat
            
    // Obtains the current scaling and font the user chose
    init() {
        font = AccesibilityRequirement().getFont()
        fontScale = AccesibilityRequirement().getFontScale()
        AccesibilityRequirement().$font
            .assign(to: &$font)
        AccesibilityRequirement().$fontScale
            .assign(to: &$fontScale)
    }
    
    // Gets the current font that the user chose
    func getFont() -> String {
        return font
    }
    
    // Gets the current font scaling the user chose
    func getFontScale() -> CGFloat {
        return fontScale
    }
}
