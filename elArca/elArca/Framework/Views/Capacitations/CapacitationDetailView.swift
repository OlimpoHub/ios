import SwiftUI

struct CapacitationsDetailView: View {
    @StateObject var viewModel: DiscapacityDetailViewModel
    @Environment(\.presentationMode) var presentationMode

    init(id: String) {
        _viewModel = StateObject(wrappedValue: DiscapacityDetailViewModel(id: id))
    }

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with back button and title
                HStack(spacing: 16) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }

                    if let name = viewModel.discapacity?.name {
                        Texts(text: name, type: .header)
                            .foregroundColor(.white)
                    } else {
                        Texts(text: "Discapacidad", type: .header)
                            .foregroundColor(.white)
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 16)

                // Content
                Group {
                    if viewModel.isLoading {
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                                .padding()
                            Texts(text: "Cargando...", type: .medium)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = viewModel.errorMessage {
                        Texts(text: error, type: .medium)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(24)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let discapacity = viewModel.discapacity {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 24) {
                                // Discapacity Description Section
                                VStack(alignment: .leading, spacing: 12) {
                                    Texts(text: "Descripción", type: .subtitle)
                                        .foregroundColor(.white)

                                    Texts(
                                        text: discapacity.descripcion ?? "No hay descripción proporcionada.",
                                        type: .medium
                                    )
                                    .foregroundColor(.white)
                                    .lineSpacing(4)
                                }

                                // Image placeholder
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 180)
                                    .cornerRadius(12)

                                Spacer(minLength: 20)
                            }
                            .padding(24)
                        }
                    } else {
                        Texts(text: "No hay información disponible.", type: .medium)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(24)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
