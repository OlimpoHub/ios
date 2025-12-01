//
//  AttendanceRepository.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 30/11/25.
//

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
    
    func sendAttendance(qrValue: String, readTime: Int, userID: String) async -> AttendanceInfo {
        do {
            return await service.sendAttendance(url: URL(string: "\(Api.base)\(Api.routes.attendance)")!, qrValue: qrValue, readTime: readTime, userID: userID)
        }
    }
}
