//
//  BeneficiaryRepository.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 11/11/25.
//

import Foundation

protocol BeneficiaryRepositoryProtocol {
    func getBeneficiaries() async -> [BeneficiaryResponse]?
    func getBeneficiary(id: String) async -> BeneficiaryResponse?
}

final class BeneficiaryRepository: BeneficiaryRepositoryProtocol {
    static let shared = BeneficiaryRepository()

    private var storage: [BeneficiaryResponse] = []
    private var didLoadFromAPI = false

    init() {}

    private func ensureLoaded() async {
        guard !didLoadFromAPI else { return }
        didLoadFromAPI = true
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return
        }

        do {
            print("Fetching beneficiary from: \(baseURL.appendingPathComponent(Api.routes.beneficiary).absoluteString)")
            storage = try await BeneficiaryService.shared.getBeneficiaries(
                baseURL: baseURL,
                path: Api.routes.beneficiary
            )
            print("✅ Successfully fetched and stored \(storage.count) beneficiaries")
            for b in storage {
                print("🧾 \(b.nombre) \(b.apellidoPaterno) - ID: \(b.idBeneficiario)")
            }
        } catch {
            print("❌ Error al cargar beneficiarios: \(error)")
            print("Error details: \(error.localizedDescription)")
        }

    }

    func getBeneficiaries() async -> [BeneficiaryResponse]? {
        await ensureLoaded()
        return storage
    }

    func getBeneficiary(id: String) async -> BeneficiaryResponse? {
        if let found = storage.first(where: { $0.idBeneficiario == id }) {
            return found
        }

        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return nil
        }

        do {
            let beneficiary = try await BeneficiaryService.shared.getBeneficiary(
                baseURL: baseURL,
                path: Api.routes.beneficiary,
                id: id
            )
            storage.append(beneficiary)
            return beneficiary
        } catch {
            print("Error fetching beneficiary with id \(id): \(error)")
            return nil
        }
    }
}
