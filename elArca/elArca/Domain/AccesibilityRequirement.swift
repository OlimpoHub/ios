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
    
    init(dataRepository: AccesibilityRepositoryProtocol = AccesibilityRepository.shared) {
        self.dataRepository = dataRepository
        self.dyslexicToggle = dataRepository.getDyslexicToggle()
        self.biggerFontToggle = dataRepository.getBiggerFontToggle()
        self.font = ""
        self.fontScale = 0
        
        completeInit()
    }
    
    func completeInit() -> Void {
        self.font = getFont()
        self.fontScale = getFontScale()
    }
    
    func getFont() -> String {
        let toggleValue = dataRepository.getDyslexicToggle()
        if toggleValue {
            return "OpenDyslexicThree"
        }
        return "Poppins"
    }
    
    func setDyslexicToggle(value: Bool) -> Void {
        dataRepository.setDyslexicToggle(value: value)
        self.dyslexicToggle = dataRepository.getDyslexicToggle()
        self.fontScale = getFontScale()
        print("Set dyslexic toggle value to \(value)")
    }
    
    func getFontScale() -> CGFloat {
        let toggleValue = dataRepository.getBiggerFontToggle()
        if toggleValue {
            return 1.2
        }
        return 1
    }
    
    func setBiggerFontToggle(value: Bool) -> Void {
        dataRepository.setBiggerFontToggle(value: value)
        self.dyslexicToggle = dataRepository.getBiggerFontToggle()
        self.fontScale = getFontScale()
        print("Set bigger font toggle value to \(value)")
    }
}
