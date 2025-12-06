//
//  CDBEneficiary.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 01/12/25.
// Core Data entity for beneficiary data stored locally.
// - Properties mirror BeneficiaryResponse fields and are used by repo mappers.

import Foundation
import CoreData

@objc(CDBeneficiary)
public class CDBeneficiary: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDBeneficiary> {
        return NSFetchRequest<CDBeneficiary>(entityName: "CDBeneficiary")
    }

    @NSManaged public var idBeneficiario: String
    @NSManaged public var nombre: String
    @NSManaged public var apellidoPaterno: String
    @NSManaged public var apellidoMaterno: String?
    @NSManaged public var fechaNacimiento: Date?
    @NSManaged public var numeroEmergencia: String?
    @NSManaged public var nombreContactoEmergencia: String?
    @NSManaged public var relacionContactoEmergencia: String?
    @NSManaged public var descripcion: String?
    @NSManaged public var fechaIngreso: Date?
    @NSManaged public var foto: String?
    @NSManaged public var estatus: Int16


    @NSManaged public var discapacidades: String?
    @NSManaged public var discapacidad: String?         
}
