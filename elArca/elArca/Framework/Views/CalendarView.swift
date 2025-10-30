//
//  CalendarView.swift
//  elArca
//
//  Created by Fátima Figueroa on 30/10/25.
//

import SwiftUI

enum Constants {
    static let dayHeight: CGFloat = 40
    static let monthHeight: CGFloat = 48 * 5
}

struct CalendarView: View {
    @State private var selection: Date?
    @State private var title: String = Calendar.monthAndYear(from: .now)
    @State private var focusedWeek: Week = .current
    @State private var calendarType: CalendarType = .week
    @State private var isDragging: Bool = false
    
    @State private var dragProgress: CGFloat = .zero
    @State private var initialDragOffset: CGFloat? = nil
    @State private var verticalDragOffset: CGFloat = .zero
    
    private let symbols = ["Lu", "Ma", "Mi", "Ju", "Vi", "Sa", "Do"]
    
    enum CalendarType {
        case week, month
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.gray.opacity(0.2).ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(title).font(.title2.bold())
                    Spacer()
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                
                HStack {
                    ForEach(symbols, id: \.self) { symbol in
                        Text(symbol)
                            .fontWeight(.medium)
                            .frame(minWidth: .infinity)
                            .foregroundStyle(.secondary)
                        
                        if symbol != symbols.last {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack {
                    switch calendarType {
                    case .week:
                        WeekCalendarView(
                            $title,
                            selection: $selection,
                            focused: $focusedWeek,
                            isDragging: isDragging
                        )
                    case .month:
                        MonthCalendarView(
                            $title,
                            selection: $selection,
                            focused: $focusedWeek,
                            isDragging: isDragging,
                            dragProgress: dragProgress
                        )
                    }
                }
                .frame(height: Constants.dayHeight + verticalDragOffset)
                .clipped()
                
                Capsule()
                    .fill(.gray.mix(with: .white, by: 0.6))
                    .frame(width: 40, height: 4)
                    .padding(.bottom, 6)
            }
            .background(
                UnevenRoundedRectangle(
                    cornerRadii: .init(bottomLeading: 16, bottomTrailing: 16)
                )
                .fill(.white)
                .ignoresSafeArea()
            )
            .onChange(of: selection) {}
            .onChange(of: focusedWeek) { _, n in
                print(n.id)
            }
            .gesture(
                DragGesture(minimumDistance: .zero)
                    .onChanged { value in
                        isDragging = true
                        CalendarType = verticalDragOffset == 0 ? .week : .month
                        
                        if initialDragOffset == nil {
                            initialDragOffset = verticalDragOffset
                        }
                        
                        verticalDragOffset = max (
                            .zero,
                            min (
                                (initialDragOffset ?? 0) + value.translation.height,
                                Constants.monthHeight - Constants.dayHeight
                            )
                        )
                        
                        dragProgress = verticalDragOffset / (Constants.monthHeight - Constants.dayHeight)
                    }
                    .onEnded { value in
                        isDragging = false
                        initialDragOffset = nil
                        
                        withAnimation {
                            switch calendarType {
                            case .week:
                                if verticalDragOffset > Constants.monthHeight/3 {
                                    verticalDragOffset = Constants.monthHeight - Constants.dayHeight
                                } else {
                                    verticalDragOffset = 0
                                }
                            case .month:
                                if verticalDragOffset < Constants.monthHeight/3 {
                                    verticalDragOffset = 0
                                } else {
                                    verticalDragOffset = Constants.monthHeight - Constants.dayHeight
                                }
                            }
                            
                            dragProgress = verticalDragOffset / (Constants.monthHeight - Constants.dayHeight)
                        } completion: {
                            CalendarType = verticalDragOffset == 0 ? .week : .month
                        }
                    }
            )
        }
    }
}

#Preview {
    CalendarView()
}
