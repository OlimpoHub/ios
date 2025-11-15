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
    
    @State private var isPresentingScanner = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.scannedCode.isEmpty
                 ? "Escanea el QR de asistencia"
                 : "QR leído, registrando asistencia...")
                .padding()
        }
        .onAppear {
            isPresentingScanner = true
        }
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(
                codeTypes: [.qr],
                completion: { result in
                    switch result {
                    case .success(let code):
                        // send POST
                        viewModel.handleScannedCode(code.string)
                        isPresentingScanner = false
                    case .failure(let error):
                        print("Error al leer QR: \(error.localizedDescription)")
                        isPresentingScanner = false
                    }
                }
            )
        }
    }
}

#Preview {
    ReadQRView(viewModel: AttendanceViewModel())
}
