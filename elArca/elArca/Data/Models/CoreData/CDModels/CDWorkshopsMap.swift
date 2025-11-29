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

        // Convert `Fecha` (String) into Date using a seconds-level ISO pattern
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dto.Fecha) {
            self.fecha = date
        } else {
            self.fecha = Date()
        }
    }

    func toDTO() -> WorkshopResponse {
        // Emit a seconds-level ISO string (no milliseconds) matching: "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let formattedDate = dateFormatter.string(from: fecha)

        return WorkshopResponse(
            idTaller: idTaller,
            nombreTaller: nombreTaller,
            horaEntrada: horaEntrada,
            horaSalida: horaSalida,
            Fecha: formattedDate,
            URL: url,
            Descripcion: descripcion
        )
    }
}
