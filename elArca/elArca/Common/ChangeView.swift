//
//  ChangeView.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 05/11/25.
//

import SwiftUI
import FlowStacks

func changeView(screen: Screen, navigator: FlowNavigator<Screen>) {
    if screen == .home {
        navigator.goBackToRoot()
    }
    else if !navigator.goBackTo(screen) {
        navigator.push(screen)
    }
}
