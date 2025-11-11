//
//  CalendarItemsRepository.swift
//  elArca
//
//  Created by Fátima Figueroa on 03/11/25.
//
import Foundation

final class CalendarItemsRepository: CalendarItemsRequirement {
    private var storage: [Date: [DayItem]] = [:]
    private let calendar: Calendar = .current
    private var didLoadFromAPI = false

    // Hour format conversion
    private func formatoHora(_ horaString: String) -> String {
        let entradaFormatter = DateFormatter()
        entradaFormatter.dateFormat = "HH:mm:ss"
        entradaFormatter.locale = Locale(identifier: "en_US_POSIX")

        let salidaFormatter = DateFormatter()
        salidaFormatter.dateFormat = "h:mm a"
        salidaFormatter.locale = Locale(identifier: "es_MX")
        salidaFormatter.amSymbol = "a.m."
        salidaFormatter.pmSymbol = "p.m."

        if let date = entradaFormatter.date(from: horaString) {
            return salidaFormatter.string(from: date)
        } else {
            return horaString // fallback
        }
    }

    // Load data from API
    private func ensureLoaded() async {
        guard !didLoadFromAPI else { return }
        didLoadFromAPI = true
        guard let baseURL = URL(string: Api.base) else { return }

        do {
            let remote = try await CalendarService.shared.getCalendarList(
                baseURL: baseURL,
                path: Api.routes.calendar,
                limit: nil
            )

            var tmp: [Date: [DayItem]] = [:]
            for info in remote {
                let k = dayKey(info.fecha, calendar: calendar)

                let entrada = formatoHora(info.horaEntrada)
                let salida  = formatoHora(info.horaSalida)
                let detalle = "Horario: \(entrada) - \(salida)"

                let item = DayItem(
                    title: info.nombreTaller,
                    note: detalle,
                    date: info.fecha
                )
                tmp[k, default: []].append(item)
            }
            storage = tmp

        } catch {
            print("Error al cargar datos desde API:", error)
        }
    }

    func items(for day: Date) async -> [DayItem] {
        await ensureLoaded()
        return storage[dayKey(day, calendar: calendar)] ?? []
    }

    func remove(_ item: DayItem) async {
        let k = dayKey(item.date, calendar: calendar)
        storage[k]?.removeAll { $0.id == item.id }
        // TODO: llamar DELETE en backend si aplica
    }
}
