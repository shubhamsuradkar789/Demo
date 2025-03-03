//
//  HomeView.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 14/11/24.
//
import Foundation

// MARK: - HomeView
import SwiftUI
struct HomeView: View {
    @State private var showSidebar = false // Controls sidebar visibility
    @StateObject private var userManager = UserManager() // User manager instance

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // MARK: Header
                    headerView

                    // MARK: TabView (Dashboard and Profile)
                    TabView {
                        RestaruntView()
                            .tabItem {
                                Image(systemName: "house")
                                Text("Dashboard")
                            }
                        DemoView()
                            .tabItem {
                                Image(systemName: "person.circle")
                                Text("Profile")
                            }
                    }
                }
                .edgesIgnoringSafeArea(.top) // Extend header to top edges

                // MARK: Sidebar View
                if showSidebar {
                    SidebarView(showSidebar: $showSidebar)
                        .transition(.move(edge: .trailing)) // Slide-in animation from right
                        .zIndex(1) // Place sidebar above other views
                }
            }
            .overlay(
                // MARK: Sidebar Toggle and Back Button
                HStack {
                    if showSidebar {
                        // Back button to close sidebar
                        Button(action: {
                            withAnimation {
                                showSidebar = false
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.title)
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        .padding(.leading, 20) // Left padding for button
                        Spacer()
                    } else {
                        Spacer()
                        
                        // Toggle button to open sidebar
                        Button(action: {
                            withAnimation {
                                showSidebar = true
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        .padding(.trailing, 20) // Right padding for button
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) // Aligns HStack to the top
            )
        }
    }
}
