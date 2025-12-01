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
            // Use NetworkClient which will add Authorization header and handle refresh+retry
            let (data, response) = try await NetworkClient.shared.request(request)
            let statusCode = response.statusCode

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
            // The post couldn't reach the server or authentication failed
            print("Request error:", error)
            return AttendanceInfo(message: "Sin conexión a la base de datos", finished: true, reachedServer: false)
        }
    }
}
