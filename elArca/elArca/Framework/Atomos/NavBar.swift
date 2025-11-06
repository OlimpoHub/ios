//
//  NavBar.swift
//  elArca
//
//  Created by Carlos Martínez on 27/10/25.
//

import SwiftUI
import FlowStacks

enum UserNav {
    case collaborator
    case coordinator
    
    var items: [NavItem] {
        switch self {
        case .coordinator:
            return [
                NavItem(title: "Inicio", icon: "house.fill", screen: .home),
                NavItem(title: "Talleres", icon: "wrench.and.screwdriver.fill", screen: .workshop),
                NavItem(title: "Pedidos", icon: "shippingbox.fill", screen: .orders),
                NavItem(title: "Inventario", icon: "circle.grid.2x2.topleft.checkmark.filled", screen: .inventory),
                NavItem(title: "Beneficiarios", icon: "person.fill", screen: .beneficiaries)
            ]
            
        case .collaborator:
            return [
                NavItem(title: "Inicio", icon: "house.fill", screen: .home),
                NavItem(title: "Talleres", icon: "wrench.and.screwdriver.fill", screen: .workshop),
                NavItem(title: "Calendario", icon: "calendar", screen: .calendar),
                NavItem(title: "Beneficiarios", icon: "person.fill", screen: .beneficiaries)
            ]
        }
    }
}

struct NavItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let screen: Screen
}

struct NavBar: View {
    var userNav: UserNav
        
    var backgroundColor: Color = Color("Background")

    var body: some View {
        GeometryReader { geometry in
            //VStack {
                //Spacer()
                
                HStack(spacing: 0) {
                    ForEach(userNav.items) { item in
                        IconButton(
                            iconName: item.icon,
                            title: item.title,
                            screen: item.screen,
                            iconSize: geometry.size.width * 0.075,
                            textSize: geometry.size.width * 0.024,
                            iconColor: Color.white,
                            textColor: Color.white,
                            backgroundColor: backgroundColor,
                        )
                    }
                }
                .padding(.horizontal, geometry.size.width * 0.04)
                .padding(.vertical, 6)
                .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? geometry.safeAreaInsets.bottom - 5 : 5)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            //.ignoresSafeArea(edges: .bottom)
            .frame(height: 65)
        //}
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NavBar(userNav: .coordinator)
    }
}
