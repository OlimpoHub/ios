//
//  AccesibilityService.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 26/11/25.
//

import Foundation

final class AccesibilityService {
    // Lets the class be a singleton
    static let shared = AccesibilityService()
    
    // Obtains the value of the dyslexic font toggle
    func getDyslexicToggle() -> Bool {
        return UserDefaults.standard.bool(forKey: "DyslexiaFont")
    }
    
    // Sets the value of the dyslexic font toggle
    func setDyslexicToggle(value: Bool) -> Void {
        UserDefaults.standard.set(value, forKey: "DyslexiaFont")
    }
    
    // Obtains the value of the bigger font toggle
    func getBiggerFontToggle() -> Bool {
        return UserDefaults.standard.bool(forKey: "BiggerFont")
    }
    
    // Sets the value of the bigger font toggle
    func setBiggerFontToggle(value: Bool) -> Void {
        UserDefaults.standard.set(value, forKey: "BiggerFont")
    }
}
