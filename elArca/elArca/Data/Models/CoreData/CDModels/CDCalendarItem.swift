//
//  CDCalendarItem.swift
//  elArca
//
//  Created by Fátima Figueroa on 11/11/25.
//
//  Core Data entity representing a calendar item (workshop instance).

import Foundation
import CoreData

@objc(CDCalendarItem)
public class CDCalendarItem: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCalendarItem> {
        return NSFetchRequest<CDCalendarItem>(entityName: "CDCalendarItem")
    }

    @NSManaged public var idTaller: String
    @NSManaged public var idUsuario: String
    @NSManaged public var nombreTaller: String
    @NSManaged public var fecha: Date
    @NSManaged public var horaEntrada: String
    @NSManaged public var horaSalida: String
}
