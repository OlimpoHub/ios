import Foundation
import Combine

// ViewModel for managing calendar data
@MainActor
final class CalendarViewModel: ObservableObject {
    // Selected date in the calendar
    @Published var selection: Date? {
        didSet { Task { await loadForSelection() } }
    }
    // Title displaying the current month and year
    @Published var title: String = Calendar.monthAndYear(from: .now)
    // Items for the currently selected day
    @Published private(set) var itemsForSelectedDay: [DayItem] = []

    private let repo: CalendarItemsRequirementProtocol
    private let calendar: Calendar

    init(
        selection: Date? = Date(),
        repo: CalendarItemsRequirementProtocol = CalendarItemsRequirement.shared,
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
