import SwiftUI

struct FirstLoginView: View {
    @StateObject private var vm = ResetPasswordViewModel()
    @EnvironmentObject var deepLinkRouter: DeepLinkRouter

    var body: some View {
        AppBackground {
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header pinned to top (same as UpdatePasswordView)
                        VStack(alignment: .leading, spacing: 8) {
                            Texts(text: "El Arca en Querétaro I.A.P", type: .small)
                                .foregroundColor(Color("Beige"))
                            Texts(text: "Activa tu cuenta", type: .header)
                                .foregroundColor(.primary)
                        }
                        .padding(.top, 32)
                        .padding(.trailing, 132)

                        // Centered card area (same wrapper as UpdatePasswordView)
                        VStack {
                            Spacer()

                            VStack(spacing: 8) {
                                Texts(text: "Ingresa tu correo electrónico", type: .small)
                                    .foregroundColor(Color("Beige"))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                TextInput(
                                    value: $vm.email,
                                    errorMessage: $vm.emailError,
                                    label: "",
                                    placeholder: "ejemplo@correo.com",
                                    type: .textInput
                                )
                                .frame(maxWidth: .infinity)

                                RectangleButton(title: vm.isLoading ? "Enviando..." : "Enviar Correo") {
                                    vm.requestRecoveryEmail(completion: { _ in })
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)

                                // Messages under the button
                                if let info = vm.infoMessage {
                                    Texts(text: info, type: .small)
                                        .foregroundColor(Color("Beige"))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                } else if let err = vm.errorMessage {
                                    Texts(text: err, type: .small)
                                        .foregroundColor(Color("HighlightRed"))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .fill(Color(.secondarySystemBackground).opacity(0.03))
                            )
                            .padding(.horizontal, 16)
                            .frame(minHeight: geo.size.height * 0.45)

                            Spacer()
                        }
                    }
                    .frame(minHeight: geo.size.height)
                }
                .onTapGesture { hideKeyboard() }
            }
        }
    private func sendResetEmail() {
    }
}

struct FirstLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLoginView()
            .preferredColorScheme(.dark)
    }
}
