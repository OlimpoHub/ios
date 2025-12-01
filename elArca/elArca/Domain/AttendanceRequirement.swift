//
//  AttendanceRequirement.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 30/11/25.
//

import Foundation

protocol AttendanceRequirementProtocol {
    func sendAttendance(qrValue: String) async -> AttendanceInfo
    func tryToSendAttendance(qrValue: String, readTime: Int, userID: String) async -> AttendanceInfo
}

class AttendanceRequirement: AttendanceRequirementProtocol {
    let networkRepository: AttendanceRepository
    let localRepository: CDAttendanceQRRepo
    static let shared = AttendanceRequirement()
    
    init(networkRepository: AttendanceRepository = AttendanceRepository.shared, localRepository: CDAttendanceQRRepo = CDAttendanceQRRepo.shared) {
        self.networkRepository = networkRepository
        self.localRepository = localRepository
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
                    
            let initialResponse = await tryToSendAttendance(qrValue: qrValue, readTime: readTime, userID: userID)
            
            if initialResponse.reachedServer == true {
                return initialResponse
            } else {
                await localRepository.storeAttendance(qrValue: qrValue, readTime: readTime, userID: userID)
                return AttendanceInfo(message: "No se pudo conectar al servidor, se guardará la asistencia para registrarla cuando haya conexión a internet.", finished: true, reachedServer: false)
            }
        }
    }
    
    func tryToSendAttendance(qrValue: String, readTime: Int, userID: String) async -> AttendanceInfo {
        let response = await networkRepository.sendAttendance(qrValue: qrValue, readTime: readTime, userID: userID)
        return response
    }
    
    
}
