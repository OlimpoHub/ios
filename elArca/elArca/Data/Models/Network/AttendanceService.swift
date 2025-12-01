//
//  AttendanceService.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 30/11/25.
//

import Foundation

class AttendanceService {
    static let shared = AttendanceService()
    
    // Sends a post to the server to save an attendance
    func sendAttendance(url: URL, qrValue: String, readTime: Int, userID: String) async -> AttendanceInfo {
        var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "qrValue": qrValue,
                "readTime": readTime,
                "userID": userID
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

                if let bodyString = String(data: data, encoding: .utf8) {
                    print("Server response:", bodyString)
                }
                print("Status code:", statusCode)

                if (200..<300).contains(statusCode) {
                    // It was a successful post
                    return AttendanceInfo(message: "Asistencia registrada correctamente", finished: true, reachedServer: true)
                } else {
                    // The post wasn't successful, but it reached the server
                    return AttendanceInfo(message: "Error al registrar asistencia", finished: true, reachedServer: true)
                }

            } catch {
                // The post couln't reach the server
                print("Request error:", error)
                return AttendanceInfo(message: "Sin conexión a la base de datos", finished: true, reachedServer: false)
            }
    }
}
