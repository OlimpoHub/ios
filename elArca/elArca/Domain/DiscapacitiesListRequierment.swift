import Foundation

protocol DiscapacityListRequirementProtocol {
    func getDiscapacityList() async -> [DiscapacityResponse]?
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
