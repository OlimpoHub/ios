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
            
    init() {
        font = AccesibilityRequirement().getFont()
        fontScale = AccesibilityRequirement().getFontScale()
        AccesibilityRequirement().$font
            .assign(to: &$font)
        AccesibilityRequirement().$fontScale
            .assign(to: &$fontScale)
    }
    
    func getFont() -> String {
        return font
    }
    
    func getFontScale() -> CGFloat {
        return fontScale
    }
}
