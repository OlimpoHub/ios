

import Foundation

struct DiscapacityResponse: Codable, Identifiable {
    let idDiscapacidad: String
    let name: String
    let descripcion: String?
    
    
    var id: String { idDiscapacidad }
    
    
    var title: String { name }
    var detail: String { descripcion ?? "" }
    
    enum CodingKeys: String, CodingKey {
        case idDiscapacidad
        case name
        case descripcion
    }
}

