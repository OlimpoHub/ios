//
//  ApiConfig.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 07/11/25.
//

// Simple API configuration constants used by the app.
// - `base` contains the base URL for requests.
// - `routes` groups endpoint paths used by repositories/services.

struct Api {
    static let base = "http://74.208.78.8:8080/"
//  static let base = "http://localhost:8080/"
    struct routes {
        static let calendar = "calendar/"
        static let workshops = "workshop/"
        static let discapacities = "discapacity/"
        static let beneficiary = "beneficiary/"
        static let notifications = "notifications/"
        static let attendance = "qr/validate/"
        //static let otherEndpoint = "otherEndpoint/"
        //Define the endpoints here as needed and then use them in the repositories.
    }
}
