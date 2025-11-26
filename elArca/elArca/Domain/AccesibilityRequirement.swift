//
//  AccesibilityRequirement.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 26/11/25.
//

import Foundation
import Combine

protocol AccesibilityRequirementProtocol {
    func getFont() -> String
    func setDyslexicToggle(value: Bool) -> Void
    func getFontScale() -> CGFloat
    func setBiggerFontToggle(value: Bool) -> Void
}

class AccesibilityRequirement : AccesibilityRequirementProtocol, ObservableObject {
    static let shared = AccesibilityRequirement()
    
    let dataRepository: AccesibilityRepositoryProtocol
    
    @Published var dyslexicToggle: Bool
    @Published var biggerFontToggle: Bool
    @Published var font: String
    @Published var fontScale: CGFloat
    
    // Initializes the variables from the user default data
    init(dataRepository: AccesibilityRepositoryProtocol = AccesibilityRepository.shared) {
        self.dataRepository = dataRepository
        self.dyslexicToggle = dataRepository.getDyslexicToggle()
        self.biggerFontToggle = dataRepository.getBiggerFontToggle()
        self.font = ""
        self.fontScale = 0
        
        completeInit()
    }
    
    // Finishes the initialization with the needed functions
    func completeInit() -> Void {
        self.font = getFont()
        self.fontScale = getFontScale()
    }
    
    // Obtains the current font depending on the toggle value that the user chose
    func getFont() -> String {
        let toggleValue = dataRepository.getDyslexicToggle()
        if toggleValue {
            return "OpenDyslexicThree"
        }
        return "Poppins"
    }
    
    // Sets the current toogle value for the chosen font
    func setDyslexicToggle(value: Bool) -> Void {
        dataRepository.setDyslexicToggle(value: value)
        self.dyslexicToggle = dataRepository.getDyslexicToggle()
        self.fontScale = getFontScale()
        print("Set dyslexic toggle value to \(value)")
    }
    
    // Obtains the current font scaling depending on the toggle value that the user chose
    func getFontScale() -> CGFloat {
        let toggleValue = dataRepository.getBiggerFontToggle()
        if toggleValue {
            return 1.2
        }
        return 1
    }
    
    // Sets the current toogle value for the chosen font scaling
    func setBiggerFontToggle(value: Bool) -> Void {
        dataRepository.setBiggerFontToggle(value: value)
        self.dyslexicToggle = dataRepository.getBiggerFontToggle()
        self.fontScale = getFontScale()
        print("Set bigger font toggle value to \(value)")
    }
}
