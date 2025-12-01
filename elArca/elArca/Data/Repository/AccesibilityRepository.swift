//
//  AccesibilityRepository.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 26/11/25.
//

import Foundation

protocol AccesibilityRepositoryProtocol {
    func getDyslexicToggle() -> Bool
    func setDyslexicToggle(value: Bool) -> Void
    func getBiggerFontToggle() -> Bool
    func setBiggerFontToggle(value: Bool) -> Void
}

final class AccesibilityRepository: AccesibilityRepositoryProtocol {
    // Lets the class be a singleton
    static let shared = AccesibilityRepository()
    
    // Obtains the value of the dyslexic font toggle
    func getDyslexicToggle() -> Bool {
        return AccesibilityService.shared.getDyslexicToggle()
    }
    
    // Sets the value of the dyslexic font toggle
    func setDyslexicToggle(value: Bool) -> Void {
        AccesibilityService.shared.setDyslexicToggle(value: value)
    }
    
    // Obtains the value of the bigger font toggle
    func getBiggerFontToggle() -> Bool {
        return AccesibilityService.shared.getBiggerFontToggle()
    }
    
    // Sets the value of the bigger font toggle
    func setBiggerFontToggle(value: Bool) -> Void {
        AccesibilityService.shared.setBiggerFontToggle(value: value)
    }
}
