

import Foundation

struct DiscapacityResponse: Codable, Identifiable {
    let idDiscapacidad: String
    let nombre: String
    let descripcion: String?
    
    
    var id: String { idDiscapacidad }
    
    
    var title: String { nombre }
    var detail: String { descripcion ?? "" }
    
    enum CodingKeys: String, CodingKey {
        case idDiscapacidad
        case nombre
        case descripcion
    }
}

