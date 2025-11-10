//
//  CoordinatorView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 04/11/25.
//

import FlowStacks
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var accountNavigator: FlowNavigator<Account>
    
    var body: some View {
        RectangleButton(title: "Entrar"){ // TODO: Cambiar al login
            accountNavigator.presentCover(.logged)
        }
    }
}
