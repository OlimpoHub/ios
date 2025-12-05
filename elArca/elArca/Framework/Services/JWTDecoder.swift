//
//  JWTDecoder.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 21/11/25.
//

import Foundation

// Utility for decoding JSON Web Tokens (JWT)
struct JWTDecoder {
    // Decodes the payload of a JWT string
    // - Parameter jwt: The JWT string to decode
    // - Returns: A dictionary containing the decoded payload, or nil if decoding fails
    static func decodePayload(_ jwt: String) -> [String: Any]? {
        let parts = jwt.split(separator: ".")
        guard parts.count >= 2 else { return nil }
        let payloadPart = String(parts[1])

        // JWT uses base64url encoding
        // This is for when the application is offline so we can validate token without contacting the server
        
        var base64 = payloadPart
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        // Pad string to multiple of 4
        let remainder = base64.count % 4
        if remainder > 0 {
            base64 += String(repeating: "=", count: 4 - remainder)
        }

        guard let data = Data(base64Encoded: base64) else { return nil }

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as? [String: Any]
        } catch {
            return nil
        }
    }

    // Extracts the expiry date from a JWT string
    // - Parameter jwt: The JWT string from which to extract the expiry date
    // - Returns: The expiry date as a Date object, or nil if extraction fails
    static func expiryDate(from jwt: String) -> Date? {
        guard let payload = decodePayload(jwt) else { return nil }
        if let expNum = payload["exp"] as? TimeInterval {
            return Date(timeIntervalSince1970: expNum)
        }
        if let expStr = payload["exp"] as? String, let expNum = TimeInterval(expStr) {
            return Date(timeIntervalSince1970: expNum)
        }
        if let expInt = payload["exp"] as? Int {
            return Date(timeIntervalSince1970: TimeInterval(expInt))
        }
        return nil
    }

    // Checks if a JWT string is expired
    // - Parameter jwt: The JWT string to check for expiration
    // - Returns: A boolean indicating whether the JWT is expired, or nil if checking fails
    static func isExpired(_ jwt: String) -> Bool? {
        guard let exp = expiryDate(from: jwt) else { return nil }
        return Date() >= exp
    }
}
