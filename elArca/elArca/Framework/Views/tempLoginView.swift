import FlowStacks
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    @State private var showingFirstLogin = false
    @State private var showingResetPassword = false
    @EnvironmentObject var deepLinkRouter: DeepLinkRouter
    @State private var showingUpdatePassword = false
    @State private var updatePasswordToken: String = ""

    @EnvironmentObject var router: CoordinatorViewModel
    
    var body: some View {
        AppBackground {
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(spacing: 20) {
                            Image("logo-el-arca")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .padding(.vertical, 10)

                            TextInput(
                                value: $viewModel.userName,
                                errorMessage: $viewModel.userNameError,
                                label: "Correo Electrónico",
                                placeholder: "E.G. ejemplo@correo.com",
                                type: .textInput
                            )
                            .frame(maxWidth: .infinity)

                            // Password input
                            TextInput(
                                value: $viewModel.password,
                                errorMessage: $viewModel.passwordError,
                                label: "Contraseña",
                                placeholder: "••••••••••",
                                type: .passwordInput
                            )
                            .frame(maxWidth: .infinity)

                            Button(action: {
                                // present reset password view
                                showingResetPassword = true
                            }) {
                                Texts(text: "Recuperar Contraseña", type: .small)
                                    .underline()
                                    .foregroundColor(Color("Beige"))
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 6)

                            // Login button
                            RectangleButton(
                                title: "Iniciar Sesión",
                                action: {
                                    viewModel.loginTapped()
                                },
                                type: .largeBlue
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)

                            VStack {
                                if let error = viewModel.loginError {
                                    Texts(text: error, type: .small)
                                        .foregroundColor(Color("HighlightRed"))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.top, 10)
                                } else if let success = viewModel.successMessage {
                                    Texts(text: success, type: .small)
                                        .foregroundColor(.green)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.top, 10)
                                }
                            }
                            .frame(minHeight: 40)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(Color(.secondarySystemBackground).opacity(0.03))
                        )
                        .padding(.top, 40)

                        Spacer()
                            .frame(height: 70)

                        // Bottom first-login / activate account link
                        HStack {
                            Spacer()
                            Texts(text: "Si es tu primer ingreso, ", type: .small)
                                .foregroundColor(Color("Beige"))
                            Button(action: {
                                showingFirstLogin = true
                            }) {
                                Texts(text: "activa tu cuenta", type: .small)
                                    .underline()
                                    .foregroundColor(Color.blue)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 14)
                    .frame(minHeight: geo.size.height)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }
            }
        }
        .onAppear {
            viewModel.onLoginSuccess = { role in
                KeychainHelper.shared.save(role, service: "com.elarca.auth", account: "userRole")

                Task { @MainActor in
                    router.changeView(newScreen: .home)
                }
            }
        }

        .sheet(isPresented: $showingFirstLogin) {
            FirstLoginView()
        }
        .sheet(isPresented: $showingResetPassword) {
            ResetPasswordView()
        }
        // present UpdatePasswordView when deep link router publishes updatePassword
        .sheet(isPresented: $showingUpdatePassword) {
            UpdatePasswordView(token: updatePasswordToken)
        }
        .onReceive(deepLinkRouter.$activeRoute) { route in
            guard let route = route else { return }
            switch route {
            case .updatePassword(let token):
                updatePasswordToken = token
                showingUpdatePassword = true
            default:
                break
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}
