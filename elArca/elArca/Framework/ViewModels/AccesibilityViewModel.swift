//
//  AccesibilityViewModel.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 26/11/25.
//

import Foundation
import Combine

class AccesibilityViewModel: ObservableObject {
    @Published var dyslexicToggle: Bool
    @Published var biggerFontToggle: Bool
    
    var accesibilityRequirement = AccesibilityRequirement()
        
    init() {
        dyslexicToggle = accesibilityRequirement.dyslexicToggle
        biggerFontToggle = accesibilityRequirement.biggerFontToggle
    }
    
    func setDyslexicToggle(value: Bool) -> Void {
        accesibilityRequirement.setDyslexicToggle(value: value)
    }
    
    func setBiggerFontToggle(value: Bool) -> Void {
        accesibilityRequirement.setBiggerFontToggle(value: value)
    }
}
