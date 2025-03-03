//
//  SideBarView.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 14/11/24.
//
//

import SwiftUI

// MARK: - SidebarView
struct SidebarView: View {
    @Binding var showSidebar: Bool
    @EnvironmentObject var userManager: UserManager // User manager for authentication
    @State private var showLoginView = false // Controls LoginView navigation

    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 30) // Spacer to align content

            // MARK: Header
            HStack {
                Text("MEALDASH")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading)
                    .padding(.vertical, 10)
                Spacer()
            }
        
            .background(Color.black)
            .cornerRadius(5)

            // MARK: Sidebar Items
            List {
                // Profile
                NavigationLink(destination: ProfileView()) {
                    SidebarItemView(iconName: "person.circle", title: "Profile")
                }

                // Address
                NavigationLink(destination: AddressView(userManager: userManager)) {
                    SidebarItemView(iconName: "house", title: "Address")
                }

                // My Restaurant (Visible only to restaurant-owner role)
                if userManager.role == "restaurant-owner" {
                    NavigationLink(destination: MyRestaurantView(ownerId: userManager.userId ?? 0)) {
                        SidebarItemView(iconName: "building.2", title: "My Restaurant")
                    }

                    // Add Restaurant
                    NavigationLink(destination: RegisterRestaurantView(userManager: userManager)) {
                        SidebarItemView(iconName: "fork.knife", title: "Add Restaurant")
                    }
                }

                // Menu
                NavigationLink(destination: MenuView()) {
                    SidebarItemView(iconName: "list.bullet", title: "Menu")
                }

                // Orders
                NavigationLink(destination: OrdersView()) {
                    SidebarItemView(iconName: "cart", title: "Orders")
                }

                // Notifications
                NavigationLink(destination: NotificationsView()) {
                    SidebarItemView(iconName: "bell", title: "Notification")
                }

                // Chats
                NavigationLink(destination: ChatsView()) {
                    SidebarItemView(iconName: "message", title: "Chats")
                }

                // Log Out
                Button(action: {
                    userManager.logoutUser() // Log out action
                    showLoginView = true
                }) {
                    SidebarItemView(iconName: "arrow.right.square", title: "Log out", isLastItem: true)
                }
            }
            .listStyle(PlainListStyle())

            Spacer()
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .offset(x: showSidebar ? 0 : UIScreen.main.bounds.width) // Sidebar slide animation
        .animation(.easeInOut(duration: 0.3))
        .fullScreenCover(isPresented: $showLoginView) {
            LoginView() // Navigate to the login screen after logout
        }
    }
}



// MARK: - SidebarItemView
struct SidebarItemView: View {
    var iconName: String
    var title: String
    var isLastItem: Bool = false // Determines if separator is needed

    var body: some View {
        VStack {
            // Item layout
            HStack(spacing: 15) {
                Image(systemName: iconName)
                    .font(.title2)
                Text(title)
                    .font(.title3)
                Spacer()
            }
            .padding(.vertical, 15)
            .padding(.horizontal)
            .foregroundColor(.black)

            // Separator between items
            if !isLastItem {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
            }
        }
    }
}


