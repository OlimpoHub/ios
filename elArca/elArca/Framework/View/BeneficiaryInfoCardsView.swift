//
//  BeneficiarioInfoCardsView.swift
//  elArca
//
//  Created by Frida Xcaret Vargas Trejo on 31/10/25.
//

import SwiftUI

struct BeneficiarioInfoCardsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 8) {
                //nombre y return
                HStack(spacing: 8) {
                    IconButtonAtom(imageName: "return") {
                        dismiss()
                        print("regresar")
                                }
                    Texts(text: "Jafei Daidai", type: .header)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                //Dos columnas d etexto
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 15) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .cornerRadius(16)
                            .shadow(radius: 4)
                        Texts(text: "Feche de nacimiento:", type: .mediumbold)
                        Texts(text: "20/04/25", type: .medium)
                        Texts(text: "Feche de ingreso:", type: .mediumbold)
                        Texts(text: "20/04/25", type: .medium)
                        Texts(text: "Estatus:", type: .mediumbold)
                        Texts(text: "20/04/25", type: .medium)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Texts(text: "Nombre del beneficiario:", type: .mediumbold)
                        Texts(text: "Jafei Daidai", type:.medium)
                        Texts(text: "Nombre del tutor", type: .mediumbold)
                        Texts(text: "Jafei Daidai", type: .medium)
                        Texts(text: "Relación del tutor:", type: .mediumbold)
                        Texts(text: "Padre", type: .medium)
                        Texts(text: "Numero de telefono:", type: .mediumbold)
                        Texts(text: "442 378 22 90", type: .medium)
                        Texts(text: "Discapacidades:", type: .mediumbold)
                        Texts(text: "mijmimijjm", type: .medium)

                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                VStack(alignment: .leading,spacing: 8) {
                    Texts(text: "Descripción:", type: .mediumbold)
                    Texts(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vestibulum tellus metus, vel porttitor nisi rutrum id. Mauris sed metus at dolor facilisis faucibus ac in turpis. Integer erat nibh, ultricies eu bibendum et, mollis quis velit. Etiam molestie tortor non mi pellentesque dignissim. Praesent at facilisis.", type: .medium)
                }.padding(.horizontal).padding(.vertical)
                HStack(spacing: 16){
                    RectangleButton(title: "Eliminar", action: {
                                        print("eliminado")
                                    }, type: .mediumGray)
                    RectangleButton(title: "Modificar", action: {
                                        print("modificado")
                                    }, type: .mediumBlue)
                }.padding(.horizontal)
                
                Spacer()
            }
            
            NavBar()
        }
    }
}


#Preview {
    BeneficiarioInfoCardsView()
        .preferredColorScheme(.dark)
}

