//
//  ReadableDate.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 17/11/25.
//

import Foundation

// Turn a date into a human readable one
func ReadableDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MMM/yy HH:mm"
    return formatter.string(from: date)
}
