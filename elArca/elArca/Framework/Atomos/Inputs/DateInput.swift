//
//  DateInput.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 27/10/25.
//

import SwiftUI

struct DateInput: View {
    @Binding var value: Date
    
    @Binding var isValid: Bool
    @Binding var isActive: Bool
    @State private var placeholder: String = "Seleccionar aquí"
    
    var label: String
    
    let baseSize: CGFloat = 8
    let fontSize: CGFloat = 14
    let shadowSize: CGFloat = 3
    let lineWidth: CGFloat = 2
        
    var body: some View {
        // Colors and shadow are obtained depending on the current state
        let backgroundColor: Color = isValid ? Color("BlackBlue") : Color("BlackRed")
        let highlightColor: Color = isValid ? Color("HighlightBlue") : Color("HighlightRed")
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
                .fullScreenCover(isPresented: $isActive) {
                    DatePicker(selection: $value, displayedComponents: .date) {}
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .tint(.highlightBlue)
                        .onChange(of: value) {
                            isActive = false
                            placeholder = value.formatted(.dateTime.day().month().year())
                        }
                }
                
                HStack {
                    Spacer()
                    Image(systemName: "calendar")
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
        }
    }
}
