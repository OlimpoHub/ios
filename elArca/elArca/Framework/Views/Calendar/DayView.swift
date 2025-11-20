//
//  DayView.swift
//  elArca
//
//  Created by Fátima Figueroa on 29/10/25.
//

import SwiftUI

struct DayView: View {
    let date: Date
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack(spacing: 12) {
            Text(Calendar.dayNumber(from: date))
                .background {
                    if date == selectedDate {
                        Circle()
                            .foregroundStyle(.darkBlue)
                            .opacity(0.3)
                            .frame(width: 40, height: 40)
                    } else if Calendar.current.isDateInToday(date) {
                        Circle()
                            .foregroundStyle(.gray)
                            .opacity(0.3)
                            .frame(width: 40, height: 40)
                    }
                }
        }
        .foregroundStyle(selectedDate == date ? .darkBlue : .beige)
        .font(.system(.body, design: .rounded, weight: .medium))
        .onTapGesture {
            withAnimation(.easeInOut) {
                selectedDate = date
            }
        }
    }
}

#Preview {
    DayView(date: .now, selectedDate: .constant(nil))
}
