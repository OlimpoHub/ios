//
//  CoordinatorViewModel.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 11/11/25.
//

import Combine
import SwiftUI

enum Screen {
    case login
    case home
    case notifications
    case users
    case capacitations
    case dashboard
    case workshop
    case workshopDetail
    case calendar
    case beneficiaries
    case inventory
    case orders
    case attendance
    case configuration
    case none
    
    var isNavbarViewable: Bool {
        switch self {
        case .login:
            return false
        default:
            return true
        }
    }
}

class CoordinatorViewModel: ObservableObject {
    @Published var screen: Screen = .login
    
    var stack: [Screen] = [.login]
    
    // Changes the view to the one provided in screen
    func changeView(newScreen: Screen) {
        self.screen = newScreen
        stack = [newScreen]
    }
    
    func push(newScreen: Screen) {
        self.screen = newScreen
        stack.append(newScreen)
    }
    
    func pop() {
        if stack.count >= 2{
            stack.popLast()
            self.screen = stack[stack.count - 1]
        }
    }
}
