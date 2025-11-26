//
//  CDWorkshops.swift
//  elArca
//
//  Created by Fátima Figueroa on 25/11/25.
//

import Foundation
import CoreData

@objc(CDWorkshops)
public class CDWorkshops: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWorkshops> {
        return NSFetchRequest<CDWorkshops>(entityName: "CDWorkshops")
    }
    
    @NSManaged public var idTaller: String
    @NSManaged public var nombreTaller: String
    @NSManaged public var horaEntrada: String
    @NSManaged public var horaSalida: String
    @NSManaged public var fecha: Date
    @NSManaged public var url: String?
    @NSManaged public var descripcion: String?
}
