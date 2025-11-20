//
//  HasBigScreen.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 05/11/25.
//

import SwiftUI
import UIKit

// Checks wheter the user has a plus/max phone or not
func hasBigScreen() -> Bool {
    let width = UIScreen.main.bounds.width
    let isBig = width >= 410
    print(width)
    print(isBig)
    return isBig
}
