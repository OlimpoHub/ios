//
//  CalendarView.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 04/11/25.
//

import SwiftUI

enum Constants {
    static let dayHeight: CGFloat = 40
    static let monthHeight: CGFloat = 48 * 5
}

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()

    @State private var focusedWeek: Week = .current
    @State private var calendarType: CalendarType = .week
    @State private var isDragging: Bool = false

    @State private var dragProgress: CGFloat = .zero
    @State private var initialDragOffset: CGFloat? = nil
    @State private var verticalDragOffset: CGFloat = .zero

    private let symbols = ["Lu", "Ma", "Mi", "Ju", "Vi", "Sa", "Do"]

    enum CalendarType { case week, month }

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                // Header
                Texts(text: "Calendario", type: .header)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .foregroundColor(Color("Beige"))

                // month and year
                HStack {
                    Texts(text: viewModel.title, type: .subtitle)
                        .foregroundColor(Color("Beige"))
                    Spacer()
                }
                .padding(.bottom)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)

                // week days
                HStack {
                    ForEach(symbols, id: \.self) { symbol in
                        Text(symbol)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color("Beige"))
                        if symbol != symbols.last { Spacer() }
                    }
                }
                .padding(.horizontal)

                // Calendar (week/month)
                VStack {
                    switch calendarType {
                    case .week:
                        WeekCalendarView(
                            $viewModel.title,
                            selection: $viewModel.selection,
                            focused: $focusedWeek,
                            isDragging: isDragging
                        )
                    case .month:
                        MonthCalendarView(
                            $viewModel.title,
                            selection: $viewModel.selection,
                            focused: $focusedWeek,
                            isDragging: isDragging,
                            dragProgress: dragProgress
                        )
                    }
                }
                .frame(height: Constants.dayHeight + verticalDragOffset)
                .clipped()

                // Handle
                Capsule()
                    .fill(Color("Beige"))
                    .frame(width: 40, height: 4)
                    .padding(.bottom, 6)

                // List per day
                DayItemsSection(viewModel: viewModel)
                    .padding(.horizontal)
                    .animation(.default, value: viewModel.selection)
            }
            .gesture(dragGesture)
        }
    }

    // vertical gesture
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: .zero)
            .onChanged { value in
                isDragging = true
                calendarType = verticalDragOffset == 0 ? .week : .month

                if initialDragOffset == nil {
                    initialDragOffset = verticalDragOffset
                }

                verticalDragOffset = max(
                    .zero,
                    min(
                        (initialDragOffset ?? 0) + value.translation.height,
                        Constants.monthHeight - Constants.dayHeight
                    )
                )

                dragProgress = verticalDragOffset / (Constants.monthHeight - Constants.dayHeight)
            }
            .onEnded { _ in
                isDragging = false
                initialDragOffset = nil

                withAnimation {
                    switch calendarType {
                    case .week:
                        if verticalDragOffset > Constants.monthHeight / 3 {
                            verticalDragOffset = Constants.monthHeight - Constants.dayHeight
                        } else {
                            verticalDragOffset = 0
                        }
                    case .month:
                        if verticalDragOffset < Constants.monthHeight / 3 {
                            verticalDragOffset = 0
                        } else {
                            verticalDragOffset = Constants.monthHeight - Constants.dayHeight
                        }
                    }

                    dragProgress = verticalDragOffset / (Constants.monthHeight - Constants.dayHeight)
                } completion: {
                    calendarType = verticalDragOffset == 0 ? .week : .month
                }
            }
    }
}

#Preview {
    CalendarView().preferredColorScheme(.dark)
}
