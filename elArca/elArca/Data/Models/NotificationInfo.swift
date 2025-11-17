//
//  NotificationInfo.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 17/11/25.
//

import Foundation

struct NotificationInfo: Codable {
    let titulo: String
    let mensaje: String
    let fechaCreacion: Date
    let idNotificacionesUsuario: String
    let leido: Int
}

struct NotificationNewInfo: Codable {
    let size: Int
}
