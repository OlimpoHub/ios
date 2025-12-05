//
//  BeneficiaryResponse.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 11/11/25.
//

// Models used for beneficiaries returned by the API.
// - Contains the main beneficiary DTO and small helper types used for filters.

import Foundation

struct BeneficiaryResponse: Codable, Identifiable, Hashable {
    let idBeneficiario: String
    let nombre: String
    let apellidoPaterno: String
    let apellidoMaterno: String?
    let fechaNacimiento: Date?
    let numeroEmergencia: String?
    let nombreContactoEmergencia: String?
    let relacionContactoEmergencia: String?
    let descripcion: String?
    let fechaIngreso: Date?
    let foto: String?
    let estatus: Int

    let discapacidades: [String]?
    let discapacidad: String?

    // Identifiable conformance
    var id: String { idBeneficiario }
}

// Represents categories used to filter beneficiaries
struct BeneficiaryFilterCategories: Decodable {
    let disabilities: [String]

    enum CodingKeys: String, CodingKey {
        case disabilities = "discapacidad"
    }
}

// Body used to send filter criteria to the backend
struct BeneficiaryFilterBody: Encodable {
    struct Filters: Encodable {
        let discapacidades: [String]?

        enum CodingKeys: String, CodingKey {
            case discapacidades = "Discapacidades"
        }
    }

    let filters: Filters
    let order: String?
}
