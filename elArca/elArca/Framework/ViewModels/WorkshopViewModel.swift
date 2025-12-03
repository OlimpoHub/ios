import Foundation
import Combine

// --- CAPA DE FRAMEWORK (Presentation) ---
// El ViewModel siguiendo el patrón del Lab
@MainActor
class WorkshopViewModel: ObservableObject {
    
    @Published var workshops: [WorkshopResponse] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    
    var workshopListRequirement: WorkshopListRequirementProtocol
    
    private var allWorkshops: [WorkshopResponse] = []

    init(workshopListRequirement: WorkshopListRequirementProtocol = WorkshopListRequirement.shared) {
        self.workshopListRequirement = workshopListRequirement
        loadWorkshops()
    }
    
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
    
    func reloadWorkshops() async -> [WorkshopResponse] {
        await workshopListRequirement.clearStorage()
        
        let result = await workshopListRequirement.getWorkshopList()
        
        if let workshops = result {
            return workshops
        }
        
        return []
    }
    
    func filterWorkshops() {
        if searchText.isEmpty {
            self.workshops = allWorkshops
        } else {
            let lowercasedSearch = searchText.lowercased()
            self.workshops = allWorkshops.filter { $0.name.lowercased().contains(lowercasedSearch) }
        }
    }
}
