//
//  AttendanceRequirement.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 30/11/25.
//

import Foundation

protocol AttendanceRequirementProtocol {
    func sendAttendance(qrValue: String) async -> AttendanceInfo
}

class AttendanceRequirement: AttendanceRequirementProtocol {
    let networkRepository: AttendanceRepository
    static let shared = AttendanceRequirement()
    
    init(networkRepository: AttendanceRepository = AttendanceRepository.shared) {
        self.networkRepository = networkRepository
    }
    
    func sendAttendance(qrValue: String) async -> AttendanceInfo {
        do {
            // Read userID in session
            guard let userID = KeychainHelper.shared.currentUserIdFromDefaults(),
                  !userID.isEmpty else {
                print("No hay userID guardado en UserDefaults")
                return AttendanceInfo(message: "No se encontró el usuario en sesión", finished: true, reachedServer: false)
            }

            let readTime = Int(Date().timeIntervalSince1970 * 1000)
            
            let initialResponse = await networkRepository.sendAttendance(qrValue: qrValue, readTime: readTime, userID: userID)
            
            // Implement local save before
            return initialResponse
        }
    }
}
