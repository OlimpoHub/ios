import SwiftUI

struct UpdatePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ResetPasswordViewModel()

    let token: String

    // Local error messages for TextInput (non-optional required by TextInput)
    @State private var passwordError: String = ""
    @State private var confirmError: String = ""

    var body: some View {
        AppBackground {
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header pinned to top
                        VStack(alignment: .leading, spacing: 8) {
                            Texts(text: "El Arca en Querétaro I.A.P", type: .small)
                                .foregroundColor(Color("Beige"))
                            Texts(text: "Crea una contraseña para activar tu cuenta", type: .header)
                                .foregroundColor(.primary)
                        }
                        .padding(.top, 32)
                        .padding(.trailing, 48)

                        // Centered form area
                        VStack {
                            VStack(spacing: 8) {
                                Texts(text: "Ingresa una nueva contraseña", type: .small)
                                    .foregroundColor(Color("Beige"))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                TextInput(
                                    value: $vm.password,
                                    errorMessage: $passwordError,
                                    label: "",
                                    placeholder: "Nueva contraseña",
                                    type: .passwordInput
                                )
                                .frame(maxWidth: .infinity)

                                Texts(text: "Confirma tu nueva contraseña", type: .small)
                                    .foregroundColor(Color("Beige"))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                TextInput(
                                    value: $vm.confirmPassword,
                                    errorMessage: $confirmError,
                                    label: "",
                                    placeholder: "Confirmar contraseña",
                                    type: .passwordInput
                                )
                                .frame(maxWidth: .infinity)

                                RectangleButton(title: vm.isLoading ? "Procesando..." : "Establecer Contraseña") {
                                    // Clear field errors
                                    passwordError = ""
                                    confirmError = ""
                                    
                                    if vm.password != vm.confirmPassword {
                                        confirmError = "Las contraseñas no coinciden."
                                        return
                                    }

                                    vm.updatePassword(completion: { result in
                                        switch result {
                                        case .success:
                                            dismiss()
                                        case .failure(let err):
                                            vm.errorMessage = err.localizedDescription
                                        }
                                    })
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)

                                if let err = vm.errorMessage {
                                    Texts(text: err, type: .small)
                                        .foregroundColor(Color("HighlightRed"))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                if let info = vm.infoMessage {
                                    Texts(text: info, type: .small)
                                        .foregroundColor(Color("Beige"))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .fill(Color(.secondarySystemBackground).opacity(0.03))
                            )
                            .padding(.horizontal, 16)
                            .frame(minHeight: geo.size.height * 0.65) // leave space for header

                            Spacer()
                        }
                    }
                    .frame(minHeight: geo.size.height)
                }
                .onAppear {
                    vm.verifyToken(token: token)
                }
                .onTapGesture { hideKeyboard() }
            }
        }
    }
}

struct UpdatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePasswordView(token: "TEST")
            .preferredColorScheme(.dark)
    }
}
