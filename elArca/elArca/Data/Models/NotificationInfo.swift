//
//  NotificationInfo.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 17/11/25.
//

import Foundation

struct NotificationInfo: Identifiable, Codable {
    let titulo: String
    let mensaje: String
    let fechaCreacion: Date
    let idNotificacionesUsuario: String
    var leido: Int
    
    // Identifiable conformance
    var id: String { idNotificacionesUsuario }
}

struct NotificationNewInfo: Codable {
    let size: Int
}
