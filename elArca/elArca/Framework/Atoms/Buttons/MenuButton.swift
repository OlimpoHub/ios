//
//  MenuButton.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 04/11/25.
//

import SwiftUI
import SDWebImageSwiftUI
import FlowStacks

enum MenuButtonType {
    case gradient
    case solid
    
    var background: AnyView {
        switch self {
        case .gradient:
            return AnyView(
                LinearGradient(
                    colors: [Color("DarkBlue"), Color("MenuBgDark")],
                    startPoint: UnitPoint(x: 0.14, y: 0.5),
                    endPoint: UnitPoint(x: 0.96, y: 0.5))
            )
        case .solid:
            return AnyView(Color("DarkBlue"))
        }
    }
}

enum MenuButtonImage {
    case asset(String)
    case url(String)
}

struct MenuButton: View {
    var text: String
    var height: CGFloat
    var buttonType: MenuButtonType
    var image: MenuButtonImage
    var screen: Screen
    var isClickable: Bool = true
    
    @EnvironmentObject var router: CoordinatorViewModel
    
    var body: some View {
        if isClickable {
            Button(action: {
                guard isClickable else { return }
                if screen != .none {
                    router.changeView(newScreen: screen)
                }
            }) {
                structure
            }
            .buttonStyle(.plain)
            .background(buttonType.background.drawingGroup())
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .contentShape(RoundedRectangle(cornerRadius: 20))
        } else {
            structure
                .background(buttonType.background.drawingGroup())
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    // Helper function to map asset names to SF Symbols
    private func symbolForAsset(_ assetName: String) -> String {
        switch assetName {
        case "img_taller_arte":
            return "paintpalette.fill"
        case "img_taller_panaderia":
            return "birthday.cake.fill"
        case "img_taller_bisuteria":
            return "bag.fill"
        default:
            return "hammer.fill"
        }
    }
    
    var structure: some View {
        HStack {
            HStack {
                Spacer()
                Texts(text: text, type: .mediumbold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Spacer()
            }
            
            switch image {
            case .asset(let name):
                if UIImage(named: name) != nil {
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 140)
                } else {
                    let symbolName = symbolForAsset(name)
                    Image(systemName: symbolName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white.opacity(0.9))
                }
                
            case .url(let url):
                WebImage(url: URL(string: url))
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 140)
            }
            
            Spacer().frame(width: 40)
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack {
        MenuButton(text: "Boton", height: 148, buttonType: .gradient, image: .asset("house"), screen: .none)
    }
}
