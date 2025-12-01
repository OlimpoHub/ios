//
//  CDAttendanceQRRepo.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 30/11/25.
//

protocol CDAttendanceQRRepoProtocol {
    func storeAttendance(qrValue: String, readTime: Int, userID: String) -> Void
    func sendStoredAttendances() -> Bool
}

final class CDAttendanceQRRepo {
    func storeAttendance(qrValue: String, readTime: Int, userID: String) {
        // Adentro checar que no haya nada con los mismos datos, si si, no meter
        
        // Igual ver si se puede hacer sort por readTime, para que los más antiguos vayan primero, y la idea es que dentro de éste mismo, se mande a llamar el requirement, para que, en caso de que no jale, éste mande a llamar el mismo store
    }
}
