import Foundation
import Combine

@MainActor
class DiscapacityViewModel: ObservableObject {
    
    @Published var disabilities: [DiscapacityResponse] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var allDisabilities: [DiscapacityResponse] = []
    
    var disabilityListRequirement: DiscapacityListRequirementProtocol
    
    init(disabilityListRequirement: DiscapacityListRequirementProtocol = DiscapacityListRequirement.shared) {
        self.disabilityListRequirement = disabilityListRequirement
        loadDisabilities()
    }
    
    func loadDisabilities() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let result = await disabilityListRequirement.getDiscapacityList()
            
            if let list = result {
                self.allDisabilities = list
                self.filterDisabilities()
            }
            
            self.isLoading = false
        }
    }
    
    func filterDisabilities() {
        if searchText.isEmpty {
            self.disabilities = allDisabilities
        } else {
            let lower = searchText.lowercased()
            self.disabilities = allDisabilities.filter {
                $0.name.lowercased().contains(lower)
            }
        }
    }
}
