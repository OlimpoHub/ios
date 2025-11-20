import Foundation
import Combine

@MainActor
class DiscapacityDetailViewModel: ObservableObject {
    
    @Published var discapacity: DiscapacityResponse?
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var disabilityListRequirement: DiscapacityListRequirementProtocol
    
    private var allDisabilities: [DiscapacityResponse] = []

    init(id: String, disabilityListRequirement: DiscapacityListRequirementProtocol = DiscapacityListRequirement.shared) {
        self.id = id
        self.disabilityListRequirement = disabilityListRequirement
        load()
    }
    
    func load() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let result = await disabilityListRequirement.getDiscapacity (id :id)
            
            self.disability = result
        } else {
            self.errorMessage = "No se pudo cargar la información de la discapacidad."
        }

        isLoading = false
    }

}
