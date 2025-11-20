import SwiftUI

struct CapacitationsDetailView: View {
    @StateObject var viewModel: CapacitationsDetailViewModel

    init(id: String) {
        _viewModel = StateObject(wrappedValue: CapacitationsDetailViewModel(id: id))
    }

    var body: some View {
        ZStack {
            Color("BlackBlue").ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            } else if let capacit = viewModel.item {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // --- TÍTULO ---
                        Text(capacit.name)
                            .font(.custom("Poppins-Bold", size: 26))
                            .foregroundColor(.white)

                        // --- SUBTÍTULO ---
                        if !capacit.subtitle.isEmpty {
                            Text("[\(capacit.subtitle)]")
                                .font(.custom("Poppins-Regular", size: 16))
                                .foregroundColor(Color("GrayLight"))
                        }

                        // --- DESCRIPCIÓN ---
                        Text(capacit.description)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)

                        // --- IMAGEN ---
                        if let img = capacit.image, !img.isEmpty {
                            AsyncImage(url: URL(string: img)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            } placeholder: {
                                Rectangle()
                                    .fill(Color("BlackCard"))
                                    .frame(height: 180)
                                    .overlay(ProgressView())
                            }
                        }

                        // --- SECCIÓN "Sobre la capacitación" ---
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sobre la capacitación:")
                                .font(.custom("Poppins-SemiBold", size: 18))
                                .foregroundColor(.white)

                            ForEach(capacit.details, id: \.self) { detail in
                                HStack(alignment: .top, spacing: 10) {
                                    Circle()
                                        .fill(.white.opacity(0.6))
                                        .frame(width: 6, height: 6)

                                    Text(detail)
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.top, 10)

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                }

            } else {
                Text(viewModel.errorMessage ?? "Error desconocido")
                    .foregroundColor(.red)
            }
        }
    }
}
