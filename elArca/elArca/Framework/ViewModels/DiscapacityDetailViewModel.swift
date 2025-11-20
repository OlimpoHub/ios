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

    init(disabilityListRequirement: DiscapacityListRequirementProtocol = DiscapacityListRequirement.shared) {
        self.disabilityListRequirement = disabilityListRequirement
        load()
    }
    
    func load() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let result = await disabilityListRequirement.getDiscapacityList()
            
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
