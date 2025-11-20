//
//  FileInput.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 27/10/25.
//

import SwiftUI
import PhotosUI

struct FileInput: View {
    @Binding var value: String
    
    @Binding var errorMessage: String
    @State private var isActive: Bool = false
    @State private var placeholder: String = "Seleccionar aquí"
    
    var label: String
    var fileTypes: [UTType]
    
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
                HStack {
                    Texts(text: placeholder, type: .medium)
                    Spacer()
                }
                .frame(minHeight: baseSize * 3, maxHeight: baseSize * 3)
                .padding(baseSize)
                .zIndex(0)
                
                HStack {
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
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
                print("Entré")
            }
            .fileImporter(isPresented: $isActive, allowedContentTypes: fileTypes) { result in
                isActive = false
                switch result {
                case .success(let file):
                    print(file.absoluteString)
                case .failure(let error):
                    print(error.localizedDescription)
                }
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
