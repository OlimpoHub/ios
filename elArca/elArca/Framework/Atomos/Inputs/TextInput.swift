//
//  Input.swift
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
        //case .numberInput:
        //    return "arrow.up.and.down"
        //case .dateInput:
        //    return "calendar"
        case .searchInput, .searchBarInput:
            return "magnifyingglass"
        case .selectInput:
            return "arrowtriangle.down.fill"
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
    // Variable a regresar
    @Binding var value: String
    
    // Variables se estado
    @Binding var isValid: Bool
    @FocusState private var isActive: Bool
    
    var label: String
    var placeholder: String
    var options: [String] = [] // Only for dropdown menus
    
    var type: InputType = .textInput
    var error: String = ""
    
    let baseSize: CGFloat = 8
    let shadowSize: CGFloat = 3
    let lineWidth: CGFloat = 2
        
    var body: some View {
        // Se obtienen los colores y tamaños dependiendo del estado
        let backgroundColor: Color = isValid ? Color("BlackBlue") : Color("BlackRed")
        let highlightColor: Color = isValid ? Color("HighlightBlue") : Color("HighlightRed")
        let errorText: String = isValid ? "" : error
        let errorContainer: CGFloat = isValid ? 10 : 0
        let shadowSelector: CGFloat = isActive ? shadowSize : 0
        
        VStack {
            // Label
            
            // Entrada de texto
            ZStack {
                switch type {
                case .emailInput, .textInput, .searchInput, .searchBarInput:
                    TextField(placeholder, text: $value)
                        .padding(8) // Padding de adentro
                        .focused($isActive)
                        .zIndex(0)
                        
                /*case .areaInput:
                    
                case .passwordInput:
                    
                case .selectInput:*/
                default:
                    Text("xDDD")
                
                }
                
                if type.icon != "" {
                    HStack {
                        // Pushes the image to the right
                        Spacer()
                        Image(systemName: type.icon)
                            .tint(.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: baseSize * 2, height: baseSize * 2)
                            .padding(baseSize)
                            .padding(.trailing, shadowSize + lineWidth)
                    }
                }
                
                //RoundedRectangle(cornerRadius: 8).fill(Color(UIColor(red: 0, green: 0, blue: 0, alpha: 1)).shadow(.drop(color: highlightColor, radius: shadowSize)))
                  //  .zIndex(0)
            }.foregroundColor(.white)
                .frame(width: .infinity)
                .background(backgroundColor)
                .font(.custom("Poppins-SemiBold", size: baseSize * 2))
                .overlay(RoundedRectangle(cornerRadius: type.roundedCorner).stroke(highlightColor, lineWidth: lineWidth))
                .clipShape(RoundedRectangle(cornerRadius: type.roundedCorner))
                .shadow(color: highlightColor, radius: shadowSelector)
                .padding(.horizontal, shadowSize + lineWidth) // Padding que compensa el borde
                .animation(.easeInOut(duration: 0.15), value: isActive) // Animates the changes
                .animation(.easeInOut(duration: 0.3), value: isValid) // Animates the changes
        }
    }
}
