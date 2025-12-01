//
//  CDAttendanceQR.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 30/11/25.
//

import Foundation
import CoreData

@objc(CDAttendanceQR)
public class CDAttendanceQR: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAttendanceQR> {
        return NSFetchRequest<CDAttendanceQR>(entityName: "CDAttendanceQR")
    }
    
    @NSManaged public var qrValue: String
    @NSManaged public var readTime: Int
    @NSManaged public var userID: String
}
