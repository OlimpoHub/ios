import SwiftUI

struct WorkshopDetailView: View {
    @StateObject private var viewModel: WorkshopDetailViewModel
    @Environment(\.presentationMode) var presentationMode

    init(id: String) {
        _viewModel = StateObject(wrappedValue: WorkshopDetailViewModel(id: id))
    }

    init(workshop: WorkshopResponse) {
        let vm = WorkshopDetailViewModel(id: workshop.idTaller)
        vm.workshop = workshop
        _viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ZStack {
            // Background Color
            Color("Bg")
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

                    if let name = viewModel.workshop?.name {
                        Texts(text: name, type: .header)
                            .foregroundColor(.white)
                    } else {
                        Texts(text: "Taller", type: .header)
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
                    } else if let workshop = viewModel.workshop {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 24) {
                                // Workshop Description Section
                                VStack(alignment: .leading, spacing: 12) {
                                    Texts(text: "Descripción", type: .subtitle)
                                        .foregroundColor(.white)


                                    Texts(
                                        text: workshop.descripcion ?? "No hay descripción proporcionada.",
                                        type: .medium
                                    )
                                    .foregroundColor(.white)
                                    .lineSpacing(4)
                                }

                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 180)
                                    .cornerRadius(12)


                                VStack(alignment: .leading, spacing: 16) {
                                    Texts(text: "Sobre la capacitación:", type: .subtitle)
                                        .foregroundColor(.white)

                                    VStack(alignment: .leading, spacing: 12) {
                                        BulletPoint(text: "Horario: \(formatTime(workshop.startTime)) - \(formatTime(workshop.endTime))")
                                        BulletPoint(text: "Fecha: \(formatDate(workshop.date))")
                                    }
                                }

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

    // Helper function to format date string
    private func formatDate(_ dateString: String) -> String {
        // Parse seconds-level ISO string: "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = isoFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM yyyy"
            outputFormatter.locale = Locale(identifier: "es_ES")
            return outputFormatter.string(from: date)
        }

        // Fallback: try to show a readable short date
        return String(dateString.prefix(10)).replacingOccurrences(of: "-", with: "/")
    }

    // Helper to format time strings and remove seconds
    private func formatTime(_ timeString: String) -> String {
        // Expected inputs: "08:00:00", "8:00:00", or "08:00"
        // Try parsing with a strict formatter first
        let formatterWithSeconds = DateFormatter()
        formatterWithSeconds.dateFormat = "H:mm:ss"
        formatterWithSeconds.locale = Locale(identifier: "en_US_POSIX")

        if let date = formatterWithSeconds.date(from: timeString) {
            let out = DateFormatter()
            out.dateFormat = "HH:mm"
            out.locale = Locale.current
            return out.string(from: date)
        }

        // If parsing failed, try to remove seconds by splitting
        let components = timeString.split(separator: ":")
        if components.count >= 2 {
            return "\(components[0]):\(components[1])"
        }

        // Fallback: return original
        return timeString
    }
}

// Bullet point component for the training information
struct BulletPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Texts(text: "•", type: .largebold)

            Texts(text: text, type: .medium)
                .foregroundColor(.white)
        }
    }
}
