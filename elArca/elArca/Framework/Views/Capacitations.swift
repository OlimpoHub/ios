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
        VStack {
            NavigationView {
                ZStack {
                    // Background Color
                    Color("Bg")
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
                        mainContent
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
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
                talleresSection

                // --- DISCAPACIDADES ---
                discapacidadesSection

                Spacer(minLength: 100)
            }
            .padding(.top, 10)
        }
    }
    
    @ViewBuilder
    private var talleresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Texts(text: "Talleres", type: .subtitle)
                .foregroundColor(.white)
                .padding(.horizontal, 24)

            if workshopVM.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding(.vertical, 40)
                    Spacer()
                }
            } else if workshopVM.workshops.isEmpty {
                let message = search.isEmpty ?
                    "No hay talleres disponibles por el momento." :
                    "No se encontraron talleres para \"\(search)\""
                
                Text(message)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
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
                                    // Workshop Card con AsyncImage
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white)
                                            .frame(width: 140, height: 140)
                                        
                                        // Cargar imagen desde URL
                                        AsyncImage(url: URL(string: workshop.imageName)) { phase in
                                            switch phase {
                                            case .empty:
                                                // Mientras carga
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle())
                                            case .success(let image):
                                                // Imagen cargada exitosamente
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 100, height: 100)
                                            case .failure:
                                                // Si falla, mostrar el nombre como fallback
                                                Text(workshop.name)
                                                    .font(.custom("Poppins-Medium", size: 16))
                                                    .foregroundColor(.black)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.horizontal, 16)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
    @ViewBuilder
    private var discapacidadesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Texts(text: "Discapacidades", type: .subtitle)
                .foregroundColor(.white)
                .padding(.horizontal, 24)

            if discapacityVM.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding(.vertical, 40)
                    Spacer()
                }
            } else if discapacityVM.disabilities.isEmpty {
                let message = search.isEmpty ?
                    "No hay información disponible por el momento." :
                    "No se encontraron resultados para \"\(search)\""
                
                Text(message)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(discapacityVM.disabilities) { item in
                        NavigationLink(
                            destination: CapacitationsDetailView(id: item.idDiscapacidad)
                        ) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(height: 160)
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                
                                Text(item.name)
                                    .font(.custom("Poppins-Medium", size: 16))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}
