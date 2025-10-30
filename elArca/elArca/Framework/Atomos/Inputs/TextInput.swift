//
//  TextInput.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 27/10/25.
//

import SwiftUI

enum InputType {
    case emailInput
    case textInput
    case areaInput
    case passwordInput
    case searchInput
    case searchBarInput
    case selectInput
        
    var icon: String {
        switch self {
        case .emailInput:
            return "envelope.fill"
        case .passwordInput:
            return "key.horizontal.fill"
        case .searchInput, .searchBarInput:
            return "magnifyingglass"
        case .selectInput:
            return "chevron.down"
        default:
            return ""
        }
    }
    
    var roundedCorner: CGFloat {
        switch self {
        case .searchBarInput:
            return 100
        default:
            return 8
        }
    }
}

struct TextInput: View {
    @Binding var value: String
    
    @Binding var errorMessage: String
    @FocusState private var isActive: Bool
    @State private var selectedOption = "" // Only for dropdown menus
    
    var label: String
    var placeholder: String
    
    var options: [(String, String)] = [] // Only for dropdown menus
    
    var type: InputType = .textInput
    
    let baseSize: CGFloat = 8
    let fontSize: CGFloat = 14
    let shadowSize: CGFloat = 3
    let lineWidth: CGFloat = 2
    let textEditorMultiplier: CGFloat = 20
        
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
                switch type {
                    
                case .emailInput, .textInput, .searchInput, .searchBarInput:
                    TextField(placeholder, text: $value)
                        .tint(highlightColor)
                        .keyboardType(.emailAddress)
                        .frame(minHeight: baseSize * 3, maxHeight: baseSize * 3)
                        .padding(baseSize)
                        .focused($isActive)
                        .zIndex(0)
                    
                case .areaInput:
                    TextEditor(text: $value)
                        .tint(highlightColor)
                        .frame(minHeight: baseSize * textEditorMultiplier, maxHeight: baseSize * textEditorMultiplier)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, baseSize / 2)
                        .focused($isActive)
                        .zIndex(0)
                    
                case .passwordInput:
                    SecureField(placeholder, text: $value)
                        .tint(highlightColor)
                        .frame(minHeight: baseSize * 3, maxHeight: baseSize * 3)
                        .padding(baseSize)
                        .focused($isActive)
                        .zIndex(0)
                    
                case .selectInput:
                    Menu {
                        ForEach(options, id: \.1) { optionText, optionValue in
                            Button(optionText) {
                                value = optionValue
                                selectedOption = optionText
                            }
                        }
                    } label: {
                        HStack {
                            Text(value == "" ? placeholder : selectedOption)
                            Spacer()
                        }
                        .frame(minHeight: baseSize * 3, maxHeight: baseSize * 3)
                        .padding(baseSize)
                        .contentShape(Rectangle())
                    }
                    .zIndex(0)
                }
                
                if type.icon != "" {
                    HStack {
                        Spacer()
                        Image(systemName: type.icon)
                            .tint(.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: baseSize * 2, height: baseSize * 2)
                            .padding(baseSize)
                            .padding(.trailing, shadowSize + lineWidth)
                    }
                    .zIndex(1)
                }
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
            .overlay(RoundedRectangle(cornerRadius: type.roundedCorner).stroke(highlightColor, lineWidth: lineWidth))
            .clipShape(RoundedRectangle(cornerRadius: type.roundedCorner))
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
