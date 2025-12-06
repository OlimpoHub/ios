//
//  CDBeneficiaryMap.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 01/12/25.
//
import Foundation
import CoreData

extension CDBeneficiary {

    func populate(from dto: BeneficiaryResponse) {

        self.idBeneficiario = dto.idBeneficiario
        self.nombre = dto.nombre
        self.apellidoPaterno = dto.apellidoPaterno
        self.apellidoMaterno = dto.apellidoMaterno
        self.fechaNacimiento = dto.fechaNacimiento
        self.numeroEmergencia = dto.numeroEmergencia
        self.nombreContactoEmergencia = dto.nombreContactoEmergencia
        self.relacionContactoEmergencia = dto.relacionContactoEmergencia
        self.descripcion = dto.descripcion
        self.fechaIngreso = dto.fechaIngreso
        self.foto = dto.foto
        self.estatus = Int16(dto.estatus)

        // Convert array to Data for CoreData
        if let list = dto.discapacidades, !list.isEmpty {
            discapacidades = list.joined(separator: "||")
        } else if let single = dto.discapacidad, !single.isEmpty {
            discapacidades = single
        } else {
            discapacidades = nil
        }
    }

    func toDTO() -> BeneficiaryResponse {
    let listFromCore: [String]?
    if let raw = discapacidades, !raw.isEmpty {
        listFromCore = raw.components(separatedBy: "||")
    } else {
        listFromCore = nil
    }

        return BeneficiaryResponse(
            idBeneficiario: idBeneficiario,
            nombre: nombre,
            apellidoPaterno: apellidoPaterno,
            apellidoMaterno: apellidoMaterno,
            fechaNacimiento: fechaNacimiento,
            numeroEmergencia: numeroEmergencia,
            nombreContactoEmergencia: nombreContactoEmergencia,
            relacionContactoEmergencia: relacionContactoEmergencia,
            descripcion: descripcion,
            fechaIngreso: fechaIngreso,
            foto: foto,
            estatus: Int(estatus),
            discapacidades: listFromCore,
            discapacidad: listFromCore?.first ?? discapacidad
        )
    }
}

