//
//  ConfigurationView.swift
//  elArca
//
//  Created by Carlos Martinez Vazquez on 23/11/25.
//

import SwiftUI

struct ConfigurationView: View {
    @EnvironmentObject var router: CoordinatorViewModel
    @EnvironmentObject var session: SessionStore

    // Read from UserDefaults/Keychain
    private var userId: String { KeychainHelper.shared.currentUserIdFromDefaults() ?? "-" }
    private var userName: String { KeychainHelper.shared.currentUserNameFromDefaults() ?? "-" }
    private var role: String { session.userRole ?? KeychainHelper.shared.read(service: "com.elarca.auth", account: "userRole") ?? "-" }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 16) {
                Button(action: {
                    router.changeView(newScreen: .home)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }

                Texts(text: "Configuración", type: .header)
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.top, 20)

            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Texts(text: "Nombre: ", type: .mediumbold)
                    Texts(text: userName, type: .medium)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Texts(text: "Rol: ", type: .mediumbold)
                    Texts(text: role, type: .medium)
                }
            }
            .padding(.vertical, 8)

            Spacer()

            Button(action: {
                // Perform logout: clear session and navigate to login
                session.clearSession()
                router.changeView(newScreen: .login)
            }) {
                HStack {
                    Spacer()
                    Text("Cerrar sesión")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(Color.red)
                .cornerRadius(8)
            }
            .padding(.bottom, 40)

        }
        .padding(.horizontal, 24)
    }
}
