//
//  BeneficiaryFilterSheet.swift
//  elArca
//
//  Created by Fátima Figueroa on 30/11/25.
//

import SwiftUI

struct BeneficiaryFilterSheet: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: BeneficiaryListViewModel

    @State private var showDisabilitySection = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { isPresented = false }
                }

            VStack(spacing: 24) {
                headerSection
                sortSection
                Divider().background(Color.white.opacity(0.2))
                disabilitySection
                buttonsSection
            }
            .padding(24)
            .background(Color("BlackBlue"))
            .cornerRadius(24)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }

    private var headerSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .foregroundColor(.white)

            Texts(text: "Filtrar", type: .subtitle)
                .foregroundColor(.white)

            Spacer()

            Button {
                withAnimation { isPresented = false }
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
            }
        }
    }

    private var sortSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Texts(text: "Orden", type: .subtitle)
                .foregroundColor(.white)

            radioRow(
                title: "A - Z",
                isSelected: viewModel.sortOrder == .nameAsc
            ) {
                viewModel.sortOrder = .nameAsc
            }

            radioRow(
                title: "Z - A",
                isSelected: viewModel.sortOrder == .nameDesc
            ) {
                viewModel.sortOrder = .nameDesc
            }
        }
    }

    private var disabilitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation { showDisabilitySection.toggle() }
            } label: {
                HStack {
                    Texts(text: "Discapacidad", type: .subtitle)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: showDisabilitySection ? "minus" : "plus")
                        .foregroundColor(.white)
                }
            }

            if showDisabilitySection {
                disabilityContent
                    .padding(.top, 4)
            }
        }
    }

    @ViewBuilder
    private var disabilityContent: some View {
        let disabilities = viewModel.availableDisabilities

        if disabilities.isEmpty {
            Texts(text: "No hay discapacidades registradas", type: .medium)
                .foregroundColor(.white.opacity(0.7))
        } else {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(disabilities, id: \.self) { disability in
                    let isSelected = viewModel.selectedDisabilities.contains(disability)

                    Button {
                        if isSelected {
                            viewModel.selectedDisabilities.remove(disability)
                        } else {
                            viewModel.selectedDisabilities.insert(disability)
                        }
                    } label: {
                        HStack {
                            Texts(text: disability, type: .medium)
                                .foregroundColor(.white)

                            Spacer()

                            // Checkbox style
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
    
    private var buttonsSection: some View {
        HStack(spacing: 16) {
            RectangleButton(
                title: "Borrar todo",
                action: {
                    Task {
                        await viewModel.clearFilters()
                    }
                },
                type: .largeGray
            )

            RectangleButton(
                title: "Aplicar",
                action: {
                    Task {
                        await viewModel.applyFilters()
                        withAnimation { isPresented = false }
                    }
                },
                type: .largeBlue
            )
        }
    }

    private func radioRow(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 20, height: 20)

                    if isSelected {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)
                    }
                }

                Texts(text: title, type: .medium)
                    .foregroundColor(.white)

                Spacer()
            }
        }
    }
}
