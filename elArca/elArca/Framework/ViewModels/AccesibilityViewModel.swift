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
        
    // Obtains the current value of the toggle buttons
    init() {
        dyslexicToggle = accesibilityRequirement.dyslexicToggle
        biggerFontToggle = accesibilityRequirement.biggerFontToggle
    }
    
    // Sets the value for the dyslexic font toggle
    func setDyslexicToggle(value: Bool) -> Void {
        accesibilityRequirement.setDyslexicToggle(value: value)
    }
    
    // Sets the value fot the bigger font toggle
    func setBiggerFontToggle(value: Bool) -> Void {
        accesibilityRequirement.setBiggerFontToggle(value: value)
    }
}
