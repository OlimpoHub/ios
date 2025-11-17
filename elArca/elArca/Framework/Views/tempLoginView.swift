//
//  CoordinatorView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 04/11/25.
//

import FlowStacks
import SwiftUI

struct LoginView: View {    
    @EnvironmentObject var router: CoordinatorViewModel
    
    var body: some View {
        RectangleButton(title: "Entrar"){ // TODO: Cambiar al login
            router.changeView(newScreen: .home)
        }
    }
}
