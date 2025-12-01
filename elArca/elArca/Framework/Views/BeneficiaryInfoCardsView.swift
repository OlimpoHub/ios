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
            // Background Color
            Color("Bg")
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                // Header with back button and title
                HStack(spacing: 16) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }

                    Texts(text: "\(beneficiary.nombre) \(beneficiary.apellidoPaterno)", type: .header)
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 16)

                
                // Dos columnas
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
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
                            .padding(.bottom, 40)

                        } else {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 120, height: 120)
                                .cornerRadius(16)
                                .shadow(radius: 4)
                                .padding(.bottom, 40)

                        }
                        
                        // Fecha de nacimiento
                        Texts(text: "Fecha de nacimiento:", type: .mediumbold)
                            .padding(.bottom, 5)
                        Texts(text: ReadableDate(date: beneficiary.fechaNacimiento), type: .medium)
                            .padding(.bottom, 15)
                        
                        // Fecha de ingreso
                        Texts(text: "Fecha de ingreso:", type: .mediumbold)
                            .padding(.bottom, 5)
                        Texts(text: ReadableDate(date: beneficiary.fechaIngreso), type: .medium)
                            .padding(.bottom, 15)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Columna derecha
                   VStack(alignment: .leading, spacing: 0) {
                       // Contacto de emergencia
                       Texts(text: "Contacto de emergencia:", type: .mediumbold)
                           .multilineTextAlignment(.leading)
                           .lineLimit(2)
                           .frame(height: 46)
                       Texts(text: beneficiary.nombreContactoEmergencia ?? "N/A", type: .medium)
                           .padding(.bottom, 15)
                       
                       // Relación
                       Texts(text: "Relación del contacto:", type: .mediumbold)
                           .padding(.bottom, 5)
                       Texts(text: beneficiary.relacionContactoEmergencia ?? "N/A", type: .medium)
                           .padding(.bottom, 15)
                       
                       // Número de emergencias
                       Texts(text: "Emergencias:", type: .mediumbold)
                           .padding(.bottom, 5)
                       Texts(text: beneficiary.numeroEmergencia ?? "N/A", type: .medium)
                           .padding(.bottom, 15)
                       
                       // Discapacidades
                       Texts(text: "Discapacidad(es):", type: .mediumbold)
                           .multilineTextAlignment(.leading)
                           .lineLimit(2)
                           .frame(height: 20, alignment: .top)
                           .padding(.bottom, 8)

                       Texts(text: disabilityText, type: .medium)
                           .multilineTextAlignment(.leading)
                           .lineLimit(nil)
                           .fixedSize(horizontal: false, vertical: true)
                   }
                   .frame(maxWidth: .infinity, alignment: .leading)
               }
               .padding(.horizontal)
                // Descripción
                VStack(alignment: .leading, spacing: 5) {
                    Texts(text: "Descripción:", type: .mediumbold)
                        .padding(.bottom, 5)
                    Texts(text: beneficiary.descripcion ?? "Sin descripción.", type: .medium)
                        .padding(.bottom, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
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
    
    private var disabilityText: String {
        if let list = beneficiary.discapacidades, !list.isEmpty {
            return list.joined(separator: ", ")
        }
        if let single = beneficiary.discapacidad, !single.isEmpty {
            return single
        }
        return "Sin discapacidades registradas."
    }
    
    // Función para formatear fechas
    func ReadableDate(date: Date?) -> String {
        guard let date else { return "—" }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/YYYY"
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
        estatus: 1,
        discapacidades: ["Sin discapacidades disponibles", "Visual"],
        discapacidad: nil
    )

    BeneficiarioInfoCardsView(beneficiary: sample)
        .preferredColorScheme(.dark)
}


