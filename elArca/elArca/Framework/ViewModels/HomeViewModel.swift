//
//  HomeViewModel.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 19/11/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var userName: String = KeychainHelper.shared.currentUserNameFromDefaults() ?? ""
}
