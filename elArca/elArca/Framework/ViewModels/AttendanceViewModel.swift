//
//  AttendanceViewModel.swift
//  elArca
//
//  Created by Fátima Figueroa on 15/11/25.
//

import Foundation
import Combine

final class AttendanceViewModel: ObservableObject {
    @Published var scannedCode: String = ""
    // Se cambia por variable cuando esté el Login
    var userID: String = "aeda87dd-b9b8-11f0-b6b8-020161fa237d"

    func handleScannedCode(_ code: String) {
        scannedCode = code
        sendAttendance()
    }

    private func sendAttendance() {
        guard !scannedCode.isEmpty else { return }

        let qrValue = scannedCode
        let readTime = Int(Date().timeIntervalSince1970 * 1000)
        let userID = self.userID

        // Checar lo de la IP
        guard let url = URL(string: "http://192.168.100.9:8080/qr/validate") else { return }

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
                print("Error en la petición: \(error)")
                return
            }

            if let http = response as? HTTPURLResponse {
                print("Status code: \(http.statusCode)")
            }

            if let data = data,
               let body = String(data: data, encoding: .utf8) {
                print("Respuesta del servidor: \(body)")
            }
        }.resume()
    }

}
