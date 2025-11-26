//
//  CDWorkshopsMap.swift
//  elArca
//
//  Created by Fátima Figueroa on 25/11/25.
//

import Foundation
import CoreData

extension CDWorkshops {

    // Take into account the DTO
    func populate(from dto: WorkshopResponse) {
        self.idTaller      = dto.idTaller
        self.nombreTaller  = dto.nombreTaller
        self.horaEntrada   = dto.horaEntrada
        self.horaSalida    = dto.horaSalida
        self.url           = dto.URL
        self.descripcion   = dto.Descripcion

        // Convert `Fecha` (String ISO8601) intp Date
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dto.Fecha) {
            self.fecha = date
        } else {
            self.fecha = Date()
        }
    }

    func toDTO() -> WorkshopResponse {
        let formatter = ISO8601DateFormatter()
        let isoDate = formatter.string(from: fecha)

        return WorkshopResponse(
            idTaller: idTaller,
            nombreTaller: nombreTaller,
            horaEntrada: horaEntrada,
            horaSalida: horaSalida,
            Fecha: isoDate,
            URL: url,
            Descripcion: descripcion
        )
    }
}
