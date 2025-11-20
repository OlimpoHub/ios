

import SwiftUI


struct CapacitacionesView: View {

    // ViewModels
    @StateObject var workshopVM = WorkshopViewModel()
    @StateObject var discapacityVM = DiscapacityViewModel()

    // Search
    @State private var search: String = ""
    @State private var searchError: String = ""

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    // --- TÍTULO ---
                    Texts(text: "Capacitaciones", type: .header)
                        .padding(.horizontal)

                    // --- BUSCADOR ---
                    TextInput(
                        value: $search,
                        errorMessage: $searchError,
                        label: "",
                        placeholder: "Buscar",
                        type: .searchBarInput
                    )
                    .onChange(of: search) { newValue in
                        workshopVM.searchText = newValue
                        discapacityVM.searchText = newValue
                    }

                    // --- TALLERES ---
                    VStack(alignment: .leading) {
                        Texts(text: "Talleres", type: .medium)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(workshopVM.workshops) { workshop in
                                    NavigationLink(
                                        destination: WorkshopDetailView(id: workshop.idTaller)
                                    ) {
                                        VStack {
                                            Image(workshop.image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 90, height: 90)

                                            Text(workshop.name)
                                                .foregroundColor(.white)
                                                .font(.system(size: 14))
                                        }
                                        .padding(.vertical, 8)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // --- DISCAPACIDADES ---
                    VStack(alignment: .leading) {
                        Texts(text: "Discapacidades", type: .medium)
                            .padding(.horizontal)

                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(discapacityVM.discapacities) { item in
                                NavigationLink(
                                    destination: DiscapacityDetailView(id: item.idDiscapacidad)
                                ) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("BlackBlue"))
                                        .frame(height: 120)
                                        .overlay(
                                            Text(item.nombre)
                                                .foregroundColor(.white)
                                                .font(.system(size: 14))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
            }
            .background(Color("DarkBlue").ignoresSafeArea())
        }
    }
}
