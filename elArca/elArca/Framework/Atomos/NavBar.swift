//
//  NavBar.swift
//  elArca
//
//  Created by Carlos Martínez on 27/10/25.
//

import SwiftUI

struct NavItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let action: () -> Void
}

struct NavBar: View {
    var items: [NavItem] = [
        NavItem(title: "Inicio", icon: "house-door-fill") { print("Inicio") },
        NavItem(title: "Talleres", icon: "tools") { print("Talleres") },
        NavItem(title: "Pedidos", icon: "box-seam-fill") { print("Pedidos") },
        NavItem(title: "Inventario", icon: "ui-checks-grid") { print("Inventario") },
        NavItem(title: "Beneficiarios", icon: "person-heart") { print("Beneficiarios") }
    ]
    
    var backgroundColor: Color = Color("Background")

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    ForEach(items) { item in
                        IconButton(
                            iconName: item.icon,
                            title: item.title,
                            action: item.action,
                            iconSize: geometry.size.width * 0.075,
                            textSize: geometry.size.width * 0.024,
                            iconColor: Color.white,
                            textColor: Color.white,
                            backgroundColor: backgroundColor
                        )
                    }
                }
                .padding(.horizontal, geometry.size.width * 0.04)
                .padding(.vertical, 6)
                .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? geometry.safeAreaInsets.bottom - 5 : 5)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NavBar()
    }
}
