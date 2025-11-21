import SwiftUI

struct CapacitationsDetailView: View {
    @StateObject var viewModel: DiscapacityDetailViewModel

    init(id: String) {
        _viewModel = StateObject(wrappedValue: DiscapacityDetailViewModel(id: id))
    }

    var body: some View {
        ZStack {
            Color("BlackBlue").ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            } else if let capacit = viewModel.discapacity {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // --- TÍTULO ---
                        Text(capacit.name)
                            .font(.custom("Poppins-Bold", size: 26))
                            .foregroundColor(.white)

                        // --- DESCRIPCIÓN ---
                        if let desc = capacit.descripcion, !desc.isEmpty {
                            Text(desc)
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }

            } else {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text(viewModel.errorMessage ?? "Error desconocido")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
