import Foundation
import Combine

@MainActor
class DiscapacityDetailViewModel: ObservableObject {
    
    @Published var discapacity: DiscapacityResponse?
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var id: String
    
    var disabilityListRequirement: DiscapacityListRequirementProtocol
    
    private var allDisabilities: [DiscapacityResponse] = []

    // Initializes the view model and triggers the load process
    init(id: String, disabilityListRequirement: DiscapacityListRequirementProtocol = DiscapacityListRequirement.shared) {
        self.id = id
        self.disabilityListRequirement = disabilityListRequirement
        load()
    }
    
    // Loads disability details from the data source
    func load() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = await disabilityListRequirement.getDiscapacity(id: self.id)
                self.discapacity = result
            } catch {
                self.errorMessage = "No se pudo cargar la información de la discapacidad."
            }
        }

        isLoading = false
    }

}
