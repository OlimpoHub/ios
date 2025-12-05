import Foundation

// Protocol and class for managing discapacities
protocol DiscapacityListRequirementProtocol {
    // Fetches the list of discapacities
    func getDiscapacityList() async -> [DiscapacityResponse]?
    // Fetches a specific discapacity by ID
    func getDiscapacity(id: String) async -> DiscapacityResponse?
}

class DiscapacityListRequirement: DiscapacityListRequirementProtocol {
    static let shared = DiscapacityListRequirement()
    
    let dataRepository: DiscapacityRepositoryProtocol
    
    init(dataRepository: DiscapacityRepositoryProtocol = DiscapacityRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func getDiscapacityList() async -> [DiscapacityResponse]? {
        return await dataRepository.getDiscapacities()
    }
    
    func getDiscapacity(id: String) async -> DiscapacityResponse? {
        return await dataRepository.getDiscapacity(id: id)
    }
}
