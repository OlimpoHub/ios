//
//  WorkshopDetailViewModel.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 09/11/25.
//

import Foundation
import Combine

@MainActor
class WorkshopDetailViewModel: ObservableObject {
    @Published var workshop: WorkshopResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let id: String
    private let requirement: WorkshopListRequirementProtocol

    init(id: String, requirement: WorkshopListRequirementProtocol = WorkshopListRequirement.shared) {
        self.id = id
        self.requirement = requirement
        Task {
            await fetch()
        }
    }

    func fetch() async {
        isLoading = true
        errorMessage = nil

        if let result = await requirement.getWorkshop(id: id) {
            self.workshop = result
        } else {
            self.errorMessage = "No se pudo cargar la información del taller."
        }

        isLoading = false
    }
}
