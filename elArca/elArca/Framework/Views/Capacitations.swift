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
            ZStack {
                // Background Color
                Color("Background")
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header with Title and Notification Bell
                    HStack {
                        Texts(text: "Capacitaciones", type: .header)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        NotificationButton()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 20)

                    // Main Content
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 32) {

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
                            .padding(.horizontal, 24)

                            // --- TALLERES ---
                            VStack(alignment: .leading, spacing: 16) {
                                Texts(text: "Talleres", type: .subtitle)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)

                                if workshopVM.isLoading {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .padding(.vertical, 40)
                                        Spacer()
                                    }
                                } else if workshopVM.workshops.isEmpty {
                                    Text(search.isEmpty ? "No hay talleres disponibles" : "No se encontraron talleres")
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 20)
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 24) {
                                            ForEach(workshopVM.workshops) { workshop in
                                                NavigationLink(
                                                    destination: WorkshopDetailView(workshop: workshop)
                                                ) {
                                                    VStack(spacing: 12) {
                                                        // Workshop Image
                                                        ZStack {
                                                            Circle()
                                                                .fill(Color("BlackCard"))
                                                                .frame(width: 100, height: 100)
                                                            
                                                            Image(workshop.imageName)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 70, height: 70)
                                                        }

                                                        // Workshop Name
                                                        Text(workshop.name)
                                                            .font(.custom("Poppins-Regular", size: 14))
                                                            .foregroundColor(.white)
                                                            .multilineTextAlignment(.center)
                                                            .lineLimit(2)
                                                            .frame(width: 100)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 24)
                                    }
                                }
                            }

                            // --- DISCAPACIDADES ---
                            VStack(alignment: .leading, spacing: 16) {
                                Texts(text: "Discapacidades", type: .subtitle)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)

                                if discapacityVM.isLoading {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .padding(.vertical, 40)
                                        Spacer()
                                    }
                                } else if discapacityVM.disabilities.isEmpty {
                                    Text(search.isEmpty ? "No hay información disponible" : "No se encontraron resultados")
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 20)
                                } else {
                                    LazyVGrid(columns: columns, spacing: 16) {
                                        ForEach(discapacityVM.disabilities) { item in
                                            NavigationLink(
                                                destination: CapacitationsDetailView(id: item.idDiscapacidad)
                                            ) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .fill(Color("BlackCard"))
                                                        .frame(height: 140)
                                                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                                    
                                                    Text(item.name)
                                                        .font(.custom("Poppins-Medium", size: 15))
                                                        .foregroundColor(.white)
                                                        .multilineTextAlignment(.center)
                                                        .padding(.horizontal, 16)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
                            }

                            Spacer(minLength: 100)
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
        }
    }
}
