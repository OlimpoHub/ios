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

    func handleScannedCode(_ code: String) {
        print("handleScannedCode con: \(code)")
        self.scannedCode = code
        self.message = "Registrando asistencia..."
        sendAttendance()
    }

    private func sendAttendance() {
        guard !scannedCode.isEmpty else { return }

        // Read userID in session
        guard let userID = KeychainHelper.shared.currentUserIdFromDefaults(),
              !userID.isEmpty else {
            print("No hay userID guardado en UserDefaults")
            self.message = "No se encontró el usuario en sesión"
            self.finished = true
            return
        }

        let qrValue = scannedCode
        let readTime = Int(Date().timeIntervalSince1970 * 1000)

        guard let url = URL(string: "\(Api.base)qr/validate") else { return }

        // Esta parte palante es parte del service
        Task {
            let response: AttendanceInfo = await AttendanceService().sendAttendance(url: url, qrValue: qrValue, readTime: readTime, userID: userID)
            
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
