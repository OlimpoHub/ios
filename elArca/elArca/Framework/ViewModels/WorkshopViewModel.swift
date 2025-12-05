import Foundation
import Combine

// --- CAPA DE FRAMEWORK (Presentation) ---
// ViewModel responsible for loading and filtering the workshop list
@MainActor
class WorkshopViewModel: ObservableObject {
    
    @Published var workshops: [WorkshopResponse] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var workshopListRequirement: WorkshopListRequirementProtocol
    
    private var allWorkshops: [WorkshopResponse] = []

    // Initializes the view model and loads the workshop list
    init(workshopListRequirement: WorkshopListRequirementProtocol = WorkshopListRequirement.shared) {
        self.workshopListRequirement = workshopListRequirement
        loadWorkshops()
    }
    
    // Fetches the full list of workshops from the data source
    func loadWorkshops() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let result = await workshopListRequirement.getWorkshopList()
            
            if let workshops = result {
                self.allWorkshops = workshops
                self.filterWorkshops()
            }
            
            self.isLoading = false
        }
    }
    
    // Forces a fresh reload by clearing storage before retrieving workshops
    func reloadWorkshops() async -> Void {
        await workshopListRequirement.clearStorage()
        loadWorkshops()
    }
    
    // Applies text-based filtering to the workshop list
    func filterWorkshops() {
        if searchText.isEmpty {
            self.workshops = allWorkshops
        } else {
            let lowercasedSearch = searchText.lowercased()
            self.workshops = allWorkshops.filter { $0.name.lowercased().contains(lowercasedSearch) }
        }
    }
}
