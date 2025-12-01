//
//  AttendanceViewModel.swift
//  elArca
//
//  Created by Fátima Figueroa on 15/11/25.
//

import Foundation
import Combine

import Foundation
import Combine

final class AttendanceViewModel: ObservableObject {
    @Published var scannedCode: String = ""
    @Published var message: String = "Escanea el QR de asistencia"
    @Published var finished: Bool = false
    
    var attendanceRequirement: AttendanceRequirementProtocol
    
    init(attendanceRequirement: AttendanceRequirementProtocol = AttendanceRequirement.shared) {
        self.attendanceRequirement = attendanceRequirement
    }

    func handleScannedCode(_ code: String) {
        print("handleScannedCode con: \(code)")
        self.scannedCode = code
        self.message = "Registrando asistencia..."
        sendAttendance()
    }

    private func sendAttendance() {
        guard !scannedCode.isEmpty else { return }

        // Esta parte palante es parte del service
        Task {
            let response: AttendanceInfo = await attendanceRequirement.sendAttendance(qrValue: scannedCode)
            
            finished = response.finished
            message = response.message
        }
    }

    func reset() {
        scannedCode = ""
        message = "Escanea el QR de asistencia"
        finished = false
    }
}
