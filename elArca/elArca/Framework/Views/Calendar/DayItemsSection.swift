//
//  DayItemsSection.swift
//  elArca
//
//  Created by Fátima Figueroa on 03/11/25.
//

import SwiftUI
import Foundation

struct DayItemsSection: View {
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        Group {
            if viewModel.selection == nil {
                Text("Selecciona un día para ver su lista")
                    .foregroundColor(Color("Beige"))
                    .padding(.top, 8)
            } else {
                List {
                    Section {
                        if viewModel.itemsForSelectedDay.isEmpty {
                            Texts(text: "No hay eventos para este día", type: .medium)
                                .foregroundColor(Color("Beige"))
                                .listRowBackground(Color("Background").opacity(0.3))
                        } else {
                            ForEach(viewModel.itemsForSelectedDay) { item in
                                VStack(alignment: .leading, spacing: 4) {
                                    Texts(text: item.title, type: .large)
                                        .foregroundColor(Color("Beige"))
                                    Texts(text: item.note, type: .medium)
                                        .foregroundColor(Color("Beige").opacity(0.6))
                                }
                                .padding(.vertical, 6)
                                .listRowBackground(Color("Background").opacity(0.3))
                            }
                            .onDelete { indexSet in
                                Task {
                                    for idx in indexSet {
                                        await viewModel.removeItem(viewModel.itemsForSelectedDay[idx])
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .padding(.vertical, 8)
            }
        }
    }
}
