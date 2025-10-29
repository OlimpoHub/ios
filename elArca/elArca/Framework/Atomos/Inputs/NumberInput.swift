//
//  NumberInput.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 28/10/25.
//

import SwiftUI

enum NumberType {
    case int
    case float
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .int:
            return .numberPad
        case .float:
            return .decimalPad
        }
    }
}

struct NumberInput: View {
    // Variable a regresar
    @Binding var value: CGFloat
    
    @Binding var errorMessage: String
    @FocusState private var isActive: Bool
    @State private var textValue: String = ""
    
    var label: String
    var placeholder: String
    var type: NumberType
    
    let baseSize: CGFloat = 8
    let fontSize: CGFloat = 14
    let shadowSize: CGFloat = 3
    let lineWidth: CGFloat = 2
        
    var body: some View {
        // Colors and shadow are obtained depending on the current state
        let isValid: Bool = errorMessage == ""
        let backgroundColor: Color = isValid ? Color("BlackBlue") : Color("BlackRed")
        let highlightColor: Color = isValid ? Color("HighlightBlue") : Color("HighlightRed")
        let errorHeight: CGFloat = isValid ? 0 : baseSize + shadowSize
        let shadowSelector: CGFloat = isActive ? shadowSize : 0
        
        VStack {
            // Label
            HStack {
                Spacer()
                    .frame(maxWidth: shadowSize + lineWidth)
                Texts(text: label, type: .medium)
                Spacer()
            }
            .padding(.bottom, -1 * baseSize + lineWidth)
            
            // Input
            ZStack {
                TextField(placeholder, text: $textValue)
                    .tint(highlightColor)
                    .keyboardType(type.keyboardType)
                    .frame(minHeight: baseSize * 3, maxHeight: baseSize * 3)
                    .padding(baseSize)
                    .focused($isActive)
                    .zIndex(0)
                    .onChange(of: textValue) {
                        if let number = Double(textValue) {
                            value = CGFloat(number)
                        } else {
                            value = 0
                        }
                    }
                
                HStack {
                    Spacer()
                    Image(systemName: "arrow.up.and.down")
                        .tint(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: baseSize * 2, height: baseSize * 2)
                        .padding(baseSize)
                        .padding(.trailing, shadowSize + lineWidth)
                }
                .zIndex(1)
            }
            .padding(-(baseSize + shadowSize + lineWidth)) // Protects from overflow
            .contentShape(Rectangle()) // Makes it clickable
            .padding(baseSize + shadowSize + lineWidth) // Returns the padding
            .onTapGesture { // Lets be clicked
                isActive = true
            }
            .foregroundColor(.white)
            .background(backgroundColor)
            .font(.custom("Poppins-Regular", size: fontSize))
            .overlay(RoundedRectangle(cornerRadius: baseSize).stroke(highlightColor, lineWidth: lineWidth))
            .clipShape(RoundedRectangle(cornerRadius: baseSize))
            .shadow(color: highlightColor, radius: shadowSelector)
            .padding(.horizontal, shadowSize + lineWidth) // Padding added due to the shadow and border
            .animation(.easeInOut(duration: 0.15), value: isActive)
            .animation(.easeInOut(duration: 0.3), value: isValid)
            
            // Error message
            HStack {
                Spacer()
                    .frame(maxWidth: shadowSize + lineWidth)
                Texts(text: errorMessage, type: .small)
                    .foregroundStyle(.highlightRed)
                Spacer()
            }
            .padding(.top, -(shadowSize + lineWidth))
            .frame(height: errorHeight)
            Spacer()
                .frame(height: shadowSize * (isValid ? 0 : 1))
        }
    }
}
