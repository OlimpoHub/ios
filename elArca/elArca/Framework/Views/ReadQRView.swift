//
//  ReadQRView.swift
//  elArca
//
//  Created by Fátima Figueroa on 13/11/25.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct ReadQRView: View {
    @ObservedObject var viewModel: AttendanceViewModel
    @EnvironmentObject var router: CoordinatorViewModel
    @State private var isPresentingScanner = false

    var body: some View {
        ZStack {
            Color("Bg")
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer()
                Texts(text: viewModel.message, type: .medium)
                    .multilineTextAlignment(.center)
                    .padding()
                
                //            if !viewModel.finished {
                //                HStack {
                //                    Spacer()
                //                        .frame(height: 24)
                //                }
                //                RectangleButton(title: "Abrir cámara") {
                //                    isPresentingScanner = true
                //                }
                //            }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            print("ReadQRView onAppear")
            viewModel.reset()
            isPresentingScanner = true
        }
        .onChange(of: viewModel.finished) { done in
            guard done else { return }
            // Pequeño delay para que se vea el mensaje y luego regresar
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                viewModel.reset()
                router.changeView(newScreen: .home)
            }
        }
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(
                codeTypes: [.qr],
                completion: { result in
                    switch result {
                    case .success(let code):
                        print("QR leído:", code.string)
                        viewModel.handleScannedCode(code.string)
                        isPresentingScanner = false
                    case .failure(let error):
                        print("Error al leer QR:", error.localizedDescription)
                        isPresentingScanner = false
                        viewModel.message = "Error al registrar asistencia"
                        viewModel.finished = true
                    }
                }
            )
        }
    }
}

#Preview {
    ReadQRView(viewModel: AttendanceViewModel())
        .environmentObject(CoordinatorViewModel())
}

