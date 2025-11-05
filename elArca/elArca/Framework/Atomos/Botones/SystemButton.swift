//
//  SystemButton.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 04/11/25.
//

import SwiftUI

struct SystemButton: View {
    var icon: Image
    var mainColor: Color = Color("TextColor")
    var secondaryColor: Color = Color("TextColor")
    var iconSize: CGFloat
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(mainColor, secondaryColor)
            }
        }
    }
}
