//
//  BeneficiaryListViewModel.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 11/11/25.
//

import Foundation
import Combine

enum BeneficiarySortOrder {
    case nameAsc
    case nameDesc
}

@MainActor
class BeneficiaryListViewModel: ObservableObject {
    @Published var beneficiaries: [BeneficiaryResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""

    @Published var sortOrder: BeneficiarySortOrder = .nameAsc
    @Published var selectedDisabilities: Set<String> = []   // MULTISELECT
    @Published var availableDisabilities: [String] = []

    private let repository: BeneficiaryRepositoryProtocol

    init(repository: BeneficiaryRepositoryProtocol = CDBeneficiaryRepo.shared) {
        self.repository = repository
        Task {
            await loadInitialData()
        }
    }

    func loadInitialData() async {
        await fetchBeneficiaries()
        await fetchFilterCategories()
    }

    func fetchBeneficiaries() async {
        isLoading = true
        errorMessage = nil

        if let result = await repository.getBeneficiaries() {
            beneficiaries = result
        } else {
            errorMessage = "No se pudieron cargar los beneficiarios."
        }

        isLoading = false
    }
    
    func refetchBeneficiaries() async -> [BeneficiaryResponse] {
        await repository.clearStorage()
        
        if let result = await repository.getBeneficiaries() {
            return result
        } else {
            errorMessage = "No se pudieron cargar los beneficiarios."
        }
        
        return []
    }

    private func fetchFilterCategories() async {
        guard let baseURL = URL(string: Api.base) else { return }

        do {
            let categories = try await BeneficiaryService.shared.getFilterCategories(
                baseURL: baseURL,
                path: Api.routes.beneficiary
            )
            availableDisabilities = categories.disabilities
        } catch {
            print("Error al obtener categorías de filtrado: \(error)")
        }
    }

    var filteredBeneficiaries: [BeneficiaryResponse] {
        var result = beneficiaries

        if !searchText.isEmpty {
            let text = searchText.lowercased()
            result = result.filter { b in
                let fullName = "\(b.nombre) \(b.apellidoPaterno) \(b.apellidoMaterno ?? "")"
                    .lowercased()
                return fullName.contains(text)
            }
        }

        result.sort { lhs, rhs in
            let ln = "\(lhs.nombre) \(lhs.apellidoPaterno)"
            let rn = "\(rhs.nombre) \(rhs.apellidoPaterno)"

            switch sortOrder {
            case .nameAsc:
                return ln.localizedCaseInsensitiveCompare(rn) == .orderedAscending
            case .nameDesc:
                return ln.localizedCaseInsensitiveCompare(rn) == .orderedDescending
            }
        }

        return result
    }

    func applyFilters() async {
        guard let baseURL = URL(string: Api.base) else { return }

        if selectedDisabilities.isEmpty && sortOrder == .nameAsc {
            await fetchBeneficiaries()
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let orderString: String?
            switch sortOrder {
            case .nameAsc:  orderString = "ASC"
            case .nameDesc: orderString = "DESC"
            }

            let disabilitiesArray = selectedDisabilities.isEmpty
                ? nil
                : Array(selectedDisabilities)

            let body = BeneficiaryFilterBody(
                filters: .init(discapacidades: disabilitiesArray),
                order: orderString
            )

            let filtered = try await BeneficiaryService.shared.filterBeneficiaries(
                baseURL: baseURL,
                path: Api.routes.beneficiary,
                body: body
            )

            beneficiaries = filtered
        } catch {
            print("Error al aplicar filtros: \(error)")
            errorMessage = "No se pudieron aplicar los filtros."
        }

        isLoading = false
    }

    func clearFilters() {
        sortOrder = .nameAsc
        selectedDisabilities.removeAll()

        Task {
            await fetchBeneficiaries()
        }
    }
}
