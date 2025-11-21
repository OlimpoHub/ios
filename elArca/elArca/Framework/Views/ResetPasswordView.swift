import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var vm = ResetPasswordViewModel()
    @EnvironmentObject var deepLinkRouter: DeepLinkRouter

    var body: some View {
        AppBackground {
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Texts(text: "El Arca en Querétaro I.A.P", type: .small)
                                .foregroundColor(Color("Beige"))
                            Texts(text: "¿Olvidaste\n tu contraseña?", type: .header)
                                .foregroundColor(.primary)
                        }
                        .padding(.top, 32)
                        .padding(.trailing, 142)
                        
                        VStack {
                            Spacer()
                            
                            VStack(spacing: 8) {
                                // Request-email UI (only)
                                Texts(text: "Ingresa tu correo electrónico", type: .small)
                                    .foregroundColor(Color("Beige"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                TextInput(
                                    value: $vm.email,
                                    errorMessage: $vm.emailError,
                                    label: "",
                                    placeholder: "E.G. ejemplo@correo.com",
                                    type: .textInput
                                )
                                .frame(maxWidth: .infinity)
                                
                                RectangleButton(title: vm.isLoading ? "Enviando..." : "Enviar Correo") {
                                    vm.requestRecoveryEmail(completion: { _ in })
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                
                                // Messages under the button
                                if let info = vm.infoMessage, !info.isEmpty {
                                    Texts(text: info, type: .small)
                                        .foregroundColor(Color.blue)
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
                        }
                        
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

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
            .preferredColorScheme(.dark)
            .environmentObject(DeepLinkRouter())
    }
}
