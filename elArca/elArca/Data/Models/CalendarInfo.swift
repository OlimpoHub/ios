//
//  Calendar.swift
//  elArca
//
//  Created by Fátima Figueroa on 05/11/25.
//

import Foundation

struct CalendarInfo: Codable {
    let idTaller: String
    let idCapacitacion: String
    let idUsuario: String
    let nombreTaller: String
    let horaEntrada: String      // "08:00:00"
    let horaSalida: String       // "12:00:00"
    let fecha: Date
    
    enum CodingKeys: String, CodingKey {
        case idTaller
        case idCapacitacion
        case idUsuario
        case nombreTaller
        case horaEntrada
        case horaSalida
        case fecha = "Fecha"
    }
}
