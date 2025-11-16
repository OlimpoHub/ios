//
//  BeneficiarioInfoCardsView.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 31/10/25.
//

import SwiftUI

struct BeneficiarioInfoCardsView: View {
    let beneficiary: BeneficiaryResponse
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 8) {
                // Encabezado
                HStack(spacing: 8) {
                    IconButtonAtom(imageName: "return") {
                        dismiss()
                    }
                    Texts(text: "\(beneficiary.nombre) \(beneficiary.apellidoPaterno)", type: .header)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                // Dos columnas
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 15) {
                        // Imagen
                        if let foto = beneficiary.foto, !foto.isEmpty,
                           let url = URL(string: foto) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 120, height: 120)
                            .cornerRadius(16)
                            .shadow(radius: 4)
                        } else {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 120, height: 120)
                                .cornerRadius(16)
                                .shadow(radius: 4)
                        }
                        
                        // Fechas y estatus
                        Texts(text: "Fecha de nacimiento:", type: .mediumbold)
                        Texts(text: formatDate(beneficiary.fechaNacimiento), type: .medium)
                        Texts(text: "Fecha de ingreso:", type: .mediumbold)
                        Texts(text: formatDate(beneficiary.fechaIngreso), type: .medium)
                        Texts(text: "Estatus:", type: .mediumbold)
                        Texts(text: beneficiary.estatus == 1 ? "Activo" : "Inactivo", type: .medium)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Texts(text: "Nombre del beneficiario:", type: .mediumbold)
                        Texts(text: "\(beneficiary.nombre) \(beneficiary.apellidoPaterno) \(beneficiary.apellidoMaterno)", type: .medium)
                        Texts(text: "Nombre del contacto de emergencia:", type: .mediumbold)
                        Texts(text: beneficiary.nombreContactoEmergencia ?? "N/A", type: .medium)
                        Texts(text: "Relación del contacto:", type: .mediumbold)
                        Texts(text: beneficiary.relacionContactoEmergencia ?? "N/A", type: .medium)
                        Texts(text: "Número de emergencia:", type: .mediumbold)
                        Texts(text: beneficiary.numeroEmergencia ?? "N/A", type: .medium)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                // Descripción
                VStack(alignment: .leading, spacing: 8) {
                    Texts(text: "Descripción:", type: .mediumbold)
                    Texts(text: beneficiary.descripcion ?? "Sin descripción.", type: .medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
        
                // Botones
                /*HStack(spacing: 16) {
                    RectangleButton(title: "Eliminar", action: {
                        showAlert = true
                    }, type: .mediumGray)
                    
                    RectangleButton(title: "Modificar", action: {
                        print("Modificar beneficiario")
                    }, type: .mediumBlue)
                }*/
                .padding(.horizontal)
                
                Spacer()
            }
            .alert("¿Eliminar beneficiario?",
                   isPresented: $showAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Eliminar", role: .destructive) {
                    print("Beneficiario eliminado")
                }
            } message: {
                Text("Esta acción no se puede deshacer.")
            }
        }
    }
    
    // Función para formatear fechas
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: date)
    }
}


#Preview {
    let sample = BeneficiaryResponse(
        idBeneficiario: "1",
        nombre: "Jafei",
        apellidoPaterno: "Daidai",
        apellidoMaterno: "López",
        fechaNacimiento: Date(),
        numeroEmergencia: "4423782290",
        nombreContactoEmergencia: "José Daidai",
        relacionContactoEmergencia: "Padre",
        descripcion: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        fechaIngreso: Date(),
        foto: nil,
        estatus: 1
    )
    
    BeneficiarioInfoCardsView(beneficiary: sample)
        .preferredColorScheme(.dark)
}


