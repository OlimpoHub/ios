//
//  AttendanceRepository.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 30/11/25.
//

// Attendance repository that forwards attendance posting to AttendanceService.
// - sendAttendance returns an AttendanceInfo describing the result of the attempt.

import Foundation
import Combine

protocol AttendanceRepositoryProtocol {
    func sendAttendance(qrValue: String, readTime: Int, userID: String) async -> AttendanceInfo
}

class AttendanceRepository: AttendanceRepositoryProtocol {
    let service: AttendanceService
    static let shared = AttendanceRepository()
    
    init(service: AttendanceService = AttendanceService.shared) {
        self.service = service
    }
    
    // Registers an attendance in the server
    // - Returns an AttendanceInfo which describes message, finished and if server was reached
    func sendAttendance(qrValue: String, readTime: Int, userID: String) async -> AttendanceInfo {
        do {
            return await service.sendAttendance(url: URL(string: "\(Api.base)\(Api.routes.attendance)")!, qrValue: qrValue, readTime: readTime, userID: userID)
        }
    }
}
