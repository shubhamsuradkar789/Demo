//
//  DemoView.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 14/11/24.
//

import SwiftUI

// MARK: - DemoView (Dashboard)
struct DemoView: View {
    var body: some View {
        VStack {
            Text("This is your dashboard.")
                .font(.title)
                .padding()
        }
        .navigationTitle("Dashboard")
    }
}

// MARK: - MenuView
struct MenuView: View {
    var body: some View {
        Text("Menu Page")
            .navigationTitle("Menu")
    }
}

// MARK: - OrdersView
struct OrdersView: View {
    var body: some View {
        Text("Orders Page")
            .navigationTitle("Orders")
    }
}

// MARK: - NotificationsView
struct NotificationsView: View {
    var body: some View {
        Text("Notifications Page")
            .navigationTitle("Notification")
    }
}

// MARK: - ChatsView
struct ChatsView: View {
    var body: some View {
        Text("Chats Page")
            .navigationTitle("Chats")
    }
}

// MARK: - AnalyticsView
struct AnalyticsView: View {
    var body: some View {
        Text("Analytics Page")
            .navigationTitle("Analytics")
    }
}

// MARK: - SettingsView
struct SettingsView: View {
    var body: some View {
        Text("Settings Page")
            .navigationTitle("Settings")
    }
}
