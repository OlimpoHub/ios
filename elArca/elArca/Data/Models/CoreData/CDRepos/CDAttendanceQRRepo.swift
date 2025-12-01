//
//  CDAttendanceQRRepo.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 30/11/25.
//

import Foundation
import CoreData

protocol CDAttendanceQRRepoProtocol {
    func storeAttendance(qrValue: String, readTime: Int, userID: String) async -> Void
    func deleteAttendance(qrValue: String, readTime: Int, userID: String) async -> Void
    func sendStoredAttendances() async -> Void
}

final class CDAttendanceQRRepo: CDAttendanceQRRepoProtocol {
    static let shared = CDAttendanceQRRepo()
    
    private let stack: CoreDataStack
    
    init(stack: CoreDataStack = CoreDataStack.shared) {
        self.stack = stack
    }
    
    func storeAttendance(qrValue: String, readTime: Int, userID: String) async -> Void {
        let ctx = stack.viewContext

        // Obtains the attendances that has already that same data
        let req: NSFetchRequest<CDAttendanceQR> = CDAttendanceQR.fetchRequest()
        req.predicate = NSPredicate(
            format: "qrValue == %@ AND readTime == %d AND userID == %@",
            qrValue, readTime, userID
        )

        // Checks if that assistance is already stored
        if let count = try? ctx.count(for: req), count > 0 {
            return
        }

        // Creates the attendance to save
        let obj = CDAttendanceQR(context: ctx)
        obj.qrValue = qrValue
        obj.readTime = readTime
        obj.userID = userID

        // Saves the attendance
        do {
            if ctx.hasChanges {
                try ctx.save()
                print("Attendance saved locally.")
            }
        } catch {
            print("Failed to save attendance:", error)
        }
    }
    
    func deleteAttendance(qrValue: String, readTime: Int, userID: String) async -> Void {
        let ctx = stack.viewContext
        let req: NSFetchRequest<CDAttendanceQR> = CDAttendanceQR.fetchRequest()

        // Obtains the attendances that has already that same data
        req.predicate = NSPredicate(
            format: "qrValue == %@ AND readTime == %d AND userID == %@",
            qrValue, readTime, userID
        )

        // Tries to delete the attendance from the core data
        do {
            // The attendance is deleted
            if let obj = try ctx.fetch(req).first {
                ctx.delete(obj)

                if ctx.hasChanges {
                    try ctx.save()
                }
            }
        } catch {
            print("Delete error:", error)
        }
    }
    
    func sendStoredAttendances() async -> Void {
        let ctx = stack.viewContext
        let req: NSFetchRequest<CDAttendanceQR> = CDAttendanceQR.fetchRequest()

        req.sortDescriptors = [
            NSSortDescriptor(key: "readTime", ascending: true)
        ]

        let attendances: [CDAttendanceQR] = (try? ctx.fetch(req)) ?? []
        
        if attendances.isEmpty {
            print("There are no attendances stored to send")
            return
        }
        
        for attendance in attendances {
            do {
                let result = await AttendanceRequirement.shared.tryToSendAttendance(qrValue: attendance.qrValue, readTime: attendance.readTime, userID: attendance.userID)
                
                // Doesn't matter the result, the post was successful
                if result.reachedServer && result.finished {
                    // Deletes the attendance from the local data
                    await deleteAttendance(qrValue: attendance.qrValue, readTime: attendance.readTime, userID: attendance.userID)
                }
            }
        }
    }
}
