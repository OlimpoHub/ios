//
//  BeneficiaryInfo.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 11/11/25.
//

import Foundation

struct BeneficiaryResponse: Codable, Identifiable, Hashable {
    let idBeneficiario: String
    let nombre: String
    let apellidoPaterno: String
    let apellidoMaterno: String
    let fechaNacimiento: Date?
    let numeroEmergencia: String?
    let nombreContactoEmergencia: String?
    let relacionContactoEmergencia: String?
    let descripcion: String?
    let fechaIngreso: Date?
    let foto: String?
    let estatus: Int

    var id: String { idBeneficiario }
}

