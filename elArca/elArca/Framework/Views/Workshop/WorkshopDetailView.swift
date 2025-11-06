import SwiftUI

struct WorkshopDetailView: View {
    
    let workshop: WorkshopResponse
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with back button and title
                HStack(spacing: 16) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                    
                    Texts(text: workshop.name, type: .header)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                // Content without blue container
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Workshop Description Section
                        VStack(alignment: .leading, spacing: 12) {
                            Texts(text: "Descripción", type: .subtitle)
                                .foregroundColor(.white)
                            
                            Texts(
                                text: getWorkshopDescription(),
                                type: .medium
                            )
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        }
                        
                        // Image Placeholder
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 180)
                            .cornerRadius(12)
                        
                        // Training Information Section
                        VStack(alignment: .leading, spacing: 16) {
                            Texts(text: "Sobre la capacitación:", type: .subtitle)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                BulletPoint(text: "Horario: \(workshop.startTime) - \(workshop.endTime)")
                                BulletPoint(text: "Fecha: \(formatDate(workshop.date))")
                                BulletPoint(text: "Turno: \(workshop.schedule)")
                            }
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(24)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    
    //Hardcoded descriptions based on workshop name for demo purposes
    // Helper function to get workshop description based on name
    private func getWorkshopDescription() -> String {
        let name = workshop.name.lowercased()
        
        if name.contains("carpintería") || name.contains("carpinteria") {
            return "Aprende las técnicas básicas de carpintería, desde el uso de herramientas hasta la creación de muebles simples. Este taller te brindará las habilidades necesarias para trabajar la madera de manera profesional."
        } else if name.contains("electrónica") || name.contains("electronica") {
            return "Descubre el fascinante mundo de la electrónica. En este taller aprenderás sobre circuitos, componentes electrónicos y proyectos prácticos que te permitirán crear tus propios dispositivos."
        } else if name.contains("web") {
            return "Aprende a crear sitios web modernos y responsivos. Este taller cubre HTML, CSS, JavaScript y las mejores prácticas del desarrollo web actual para que puedas construir tu presencia en línea."
        } else if name.contains("arte") {
            return "Explora tu creatividad a través de diferentes técnicas artísticas. Este taller te permitirá desarrollar tus habilidades en pintura, dibujo y otras expresiones artísticas."
        } else if name.contains("panadería") || name.contains("panaderia") || name.contains("cocina") {
            return "Aprende las técnicas fundamentales de la panadería y repostería. Desde amasar hasta hornear, descubrirás los secretos para crear deliciosos panes y postres."
        } else if name.contains("bisutería") || name.contains("bisuteria") || name.contains("joyería") || name.contains("joyeria") {
            return "Crea tus propias joyas y accesorios. Este taller te enseñará las técnicas de bisutería para diseñar piezas únicas y personalizadas."
        } else {
            return "Este taller ofrece una oportunidad única para aprender nuevas habilidades y desarrollar tu potencial en un ambiente colaborativo y profesional."
        }
    }
    
    // Helper function to format date string
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = dateFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM yyyy"
            outputFormatter.locale = Locale(identifier: "es_ES")
            return outputFormatter.string(from: date)
        }
        
        return dateString.prefix(10).replacingOccurrences(of: "-", with: "/")
    }
}

// Bullet point component for the training information
struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Texts(text: text, type: .medium)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    WorkshopDetailView(workshop: WorkshopResponse(
        idTaller: "test-001",
        nombreTaller: "Arte",
        horaEntrada: "08:00:00",
        horaSalida: "12:00:00",
        HorarioTaller: "2 p.m.",
        Fecha: "2025-11-10T06:00:00.000Z",
        URL: nil
    ))
}
