//
//  WorkshopResponse.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 04/11/25.
//

import Foundation

// Unified model - serves as both DTO and domain model
struct WorkshopResponse: Codable, Identifiable {
    let idTaller: String
    let nombreTaller: String
    let horaEntrada: String
    let horaSalida: String
    let HorarioTaller: String
    let Fecha: String
    let URL: String?
    
    // Identifiable conformance
    var id: String { idTaller }
    
    // Computed properties for cleaner UI access
    var name: String { nombreTaller }
    var startTime: String { horaEntrada }
    var endTime: String { horaSalida }
    var schedule: String { HorarioTaller }
    var date: String { Fecha }
    var url: String? { URL }
    
    // UI-only property
    var imageName: String { "img_taller_default" }
    
    enum CodingKeys: String, CodingKey {
        case idTaller
        case nombreTaller
        case horaEntrada
        case horaSalida
        case HorarioTaller
        case Fecha
        case URL
    }
}
