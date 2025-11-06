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
    
    @EnvironmentObject var navigator: FlowNavigator<Screen>
    
    var body: some View {
        HStack {
            
            HStack{
                Spacer()
                Texts(text: text, type: .largebold)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
            switch image {
            case .asset(let name):
                
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 140)
                
            case .url(let url):

                WebImage(url: URL(string: url ))
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 140)
            }
            
            Spacer()
                .frame(width: 40)
        }
        .frame(height: height)
        .background(buttonType.background)
        .padding(EdgeInsets(top: -18, leading: -18, bottom: -14, trailing: -14))
        .contentShape(Rectangle())
        .padding(EdgeInsets(top: 18, leading: 18, bottom: 14, trailing: 14))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            changeView(screen: screen, navigator: navigator)
        }
    }
}
