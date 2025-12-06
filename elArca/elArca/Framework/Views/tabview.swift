//
//  tabview.swift
//  elArca
//
//  Created by Edmundo Canedo Cervantes on 07/11/25.
//

import SwiftUI

struct taview: View {
    var body: some View {
        TabView {
            Tab("Received", systemImage: "tray.and.arrow.down.fill") {
                NotificationView(notificationType: .with)
            }
            .badge(2)


            Tab("Sent", systemImage: "tray.and.arrow.up.fill") {
                CalendarView()
            }


            Tab("Account", systemImage: "person.crop.circle.fill") {
                HomeView()
            }
            .badge("!")
        }

    }
}

#Preview {
    AppBackground{
        taview().tint(Color("Beige"))
    }.preferredColorScheme(.dark)
}
