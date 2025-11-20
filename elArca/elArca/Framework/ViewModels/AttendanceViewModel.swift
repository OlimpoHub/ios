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

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "qrValue": qrValue,
            "readTime": readTime,
            "userID": userID
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la petición:", error)
                DispatchQueue.main.async {
                    self.message = "Error al registrar asistencia"
                    self.finished = true
                }
                return
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            if let data = data,
               let body = String(data: data, encoding: .utf8) {
                print("Respuesta del servidor:", body)
            }
            print("Status code:", statusCode)

            DispatchQueue.main.async {
                if (200..<300).contains(statusCode) {
                    self.message = "Asistencia registrada correctamente"
                } else {
                    self.message = "Error al registrar asistencia"
                }
                self.finished = true
            }
        }.resume()
    }

    func reset() {
        scannedCode = ""
        message = "Escanea el QR de asistencia"
        finished = false
    }
}
