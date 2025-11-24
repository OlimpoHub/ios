//
//  BeneficiaryViewModel.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 11/11/25.
//

import Foundation
import Combine

@MainActor
class BeneficiaryListViewModel: ObservableObject {
    @Published var beneficiaries: [BeneficiaryResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: BeneficiaryRepositoryProtocol

    init(repository: BeneficiaryRepositoryProtocol = BeneficiaryRepository.shared) {
        self.repository = repository
        Task {
            await fetchBeneficiaries()
        }
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
}
