import Foundation
import Combine

@MainActor
class DisabilityViewModel: ObservableObject {
    
    @Published var disabilities: [DisabilityResponse] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var disabilityListRequirement: DisabilityListRequirementProtocol
    
    private var allDisabilities: [DisabilityResponse] = []

    init(disabilityListRequirement: DisabilityListRequirementProtocol = DisabilityListRequirement.shared) {
        self.disabilityListRequirement = disabilityListRequirement
        load()
    }
    
    func load() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let result = await disabilityListRequirement.getDisabilityList()
            
            if let disabilities = result {
                self.allDisabilities = disabilities
                self.filter()
            }
            
            self.isLoading = false
        }
    }
    
    func filter() {
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
