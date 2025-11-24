import Foundation
import Combine

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var selection: Date? {
        didSet { Task { await loadForSelection() } }
    }
    @Published var title: String = Calendar.monthAndYear(from: .now)
    @Published private(set) var itemsForSelectedDay: [DayItem] = []

    private let repo: CalendarItemsRequirement
    private let calendar: Calendar

    init(
        selection: Date? = Date(),
        repo: CalendarItemsRequirement = CDCalendarItemsRepo(),
        calendar: Calendar = .current
    ) {
        self.selection = selection
        self.repo = repo
        self.calendar = calendar

        if let sel = selection { title = Calendar.monthAndYear(from: sel) }
        Task { await loadForSelection() }
    }

    func didTap(date: Date) {
        selection = date
        title = Calendar.monthAndYear(from: date)
    }

    func removeItem(_ item: DayItem) async {
        guard let sel = selection else { return }
        await repo.remove(item)
        itemsForSelectedDay = await repo.items(for: sel)
    }

    private func loadForSelection() async {
        guard let sel = selection else {
            itemsForSelectedDay = []
            return
        }
        itemsForSelectedDay = await repo.items(for: sel)
    }
}
