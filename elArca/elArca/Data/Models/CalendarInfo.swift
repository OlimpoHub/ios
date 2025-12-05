//
//  Calendar.swift
//  elArca
//
//  Created by Fátima Figueroa on 05/11/25.
//

// Simple model for calendar items (talleres) returned by the API.
// - Codable for decoding API responses.
// - Keeps raw API field names where needed and maps the Fecha field.

import Foundation

struct CalendarInfo: Codable {
    let idTaller: String
    let idUsuario: String
    let nombreTaller: String
    let horaEntrada: String      // e.g. "08:00:00"
    let horaSalida: String       // e.g. "12:00:00"
    let fecha: Date              // Day of the workshop
    
    enum CodingKeys: String, CodingKey {
        case idTaller
        case idUsuario
        case nombreTaller
        case horaEntrada
        case horaSalida
        case fecha = "Fecha"
    }
}
