//
//  CDBeneficiaryRepo.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 01/12/25.
//

import Foundation
import CoreData

final class CDBeneficiaryRepo: BeneficiaryRepositoryProtocol {

    static let shared = CDBeneficiaryRepo()

    private let stack: CoreDataStack
    private let service: BeneficiaryService
    private var didAttemptSync = false

    init(
        stack: CoreDataStack = .shared,
        service: BeneficiaryService = .shared
    ) {
        self.stack = stack
        self.service = service
    }

    private func ensureSyncedOnce() {
        guard !didAttemptSync else { return }
        didAttemptSync = true

        Task.detached { [weak self] in
            await self?.sync()
        }
    }

    func getBeneficiaries() async -> [BeneficiaryResponse]? {
        ensureSyncedOnce()

        let ctx = stack.viewContext
        let req: NSFetchRequest<CDBeneficiary> = CDBeneficiary.fetchRequest()

        req.sortDescriptors = [
            NSSortDescriptor(key: "nombre", ascending: true),
            NSSortDescriptor(key: "apellidoPaterno", ascending: true)
        ]

        do {
            let rows = try ctx.fetch(req)
            return rows.compactMap { $0.toDTO() }
        } catch {
            print("CoreData fetch beneficiaries error:", error)
            return nil
        }
    }

    func getBeneficiary(id: String) async -> BeneficiaryResponse? {
        let ctx = stack.viewContext
        let req: NSFetchRequest<CDBeneficiary> = CDBeneficiary.fetchRequest()
        req.predicate = NSPredicate(format: "idBeneficiario == %@", id)

        // Try from Core Data
        do {
            if let row = try ctx.fetch(req).first {
                return row.toDTO()
            }
        } catch {
            print("CoreData fetch single beneficiary error:", error)
        }

        // Fallback to API
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return nil
        }

        do {
            let dto = try await service.getBeneficiary(
                baseURL: baseURL,
                path: Api.routes.beneficiary,
                id: id
            )

            // Store in Core Data
            let bgCtx = stack.newBackgroundContext()

            try await bgCtx.perform {
                let obj = CDBeneficiary(context: bgCtx)
                obj.populate(from: dto)
                if bgCtx.hasChanges {
                    try bgCtx.save()
                }
            }

            return dto

        } catch {
            print("Error fetching beneficiary from API with id \(id):", error)
            return nil
        }
    }
    func getFilterCategories() async -> BeneficiaryFilterCategories? {
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return nil
        }

        do {
            let categories = try await service.getFilterCategories(
                baseURL: baseURL,
                path: Api.routes.beneficiary
            )
            return categories
        } catch {
            print("Error fetching filter categories:", error)
            return nil
        }
    }

    func filterBeneficiaries(order: String?, disabilities: [String]) async -> [BeneficiaryResponse]? {
        guard let baseURL = URL(string: Api.base) else {
            print("Error: Invalid base URL")
            return nil
        }

        let body = BeneficiaryFilterBody(
            filters: .init(discapacidades: disabilities),
            order: order
        )

        do {
            let filtered = try await service.filterBeneficiaries(
                baseURL: baseURL,
                path: Api.routes.beneficiary,
                body: body
            )
            return filtered
        } catch {
            print("Error filtering beneficiaries:", error)
            return nil
        }
    }

    func clearStorage() async {
        await self.sync()
        return
    }
    
    func sync() async {
        guard let baseURL = URL(string: Api.base) else {
            print("Api.base inválida")
            return
        }

        do {
            let remote = try await service.getBeneficiaries(
                baseURL: baseURL,
                path: Api.routes.beneficiary
            )

            print("Sync Beneficiaries: la API regresó \(remote.count) registros")

            let ctx = stack.newBackgroundContext()

            try await ctx.perform {
                // Limpiar previos
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDBeneficiary")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
                try ctx.execute(deleteRequest)

                // Insertar nuevos
                for dto in remote {
                    let obj = CDBeneficiary(context: ctx)
                    obj.populate(from: dto)
                }

                if ctx.hasChanges {
                    try ctx.save()
                }
            }

            // count elements
            let viewCtx = stack.viewContext
            let countReq: NSFetchRequest<CDBeneficiary> = CDBeneficiary.fetchRequest()
            let total = (try? viewCtx.count(for: countReq)) ?? -1

            print("Core Data Beneficiaries ahora tiene \(total) registros guardados")

        } catch {
            print("Sync Beneficiaries falló (offline sigue funcionando):", error)
        }
    }
}

