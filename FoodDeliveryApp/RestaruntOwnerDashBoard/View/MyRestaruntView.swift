//
//  MyRestaruntView.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 29/11/24.

import SwiftUI
import SDWebImageSwiftUI

struct MyRestaurantView: View {
    @ObservedObject var viewModel = MyRestaurantViewModel() // ViewModel to manage restaurant data
    let ownerId: Int // Owner ID to fetch restaurants dynamically
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Title Section
            Text("Restaurant Dashboard")
                .font(.title)
                .foregroundColor(.black)
                .padding(.top)
            
            // Restaurant List Section
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView("Loading...") // Show loading indicator
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    else if viewModel.restaurants.isEmpty {
                        Text("No restaurants found.") // Display when no restaurants are available
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 100)
                    }
                    else {
                        // Display each restaurant
                        ForEach(viewModel.restaurants) { restaurant in
                            NavigationLink(destination: AddMenuItemView(restaurantId: restaurant.id, ownerId: ownerId)) {
                                VStack(spacing: 16) {
                                    HStack {
                                        if let imageUrl = restaurant.imageUrl, let url = URL(string: imageUrl) {
                                            WebImage(url: url)
                                                .resizable()
                                                .indicator(.activity)
                                                .scaledToFill()
                                                .frame(width: 110, height: 110)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        } else {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .foregroundColor(.gray)
                                                .shadow(radius: 4)
                                        }
                                        // Restaurant details
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(restaurant.name) // Restaurant name
                                                .font(.title3)
                                                .foregroundColor(.blue)
                                            Text("Phone: \(restaurant.phoneNumber)")
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            Text("Opening Time: \(MyRestaurantViewModel.formatTime(restaurant.openingTime))")
                                                .font(.subheadline)
                                            Text("Closing Time: \(MyRestaurantViewModel.formatTime(restaurant.closingTime))")
                                                .font(.subheadline)
                                            Text(restaurant.isActive ? "Active" : "Inactive") // Active/Inactive status
                                                .foregroundColor(restaurant.isActive ? .green : .red)
                                                .font(.headline)
                                                .bold()
                                        }
                                        .padding(.leading, 8) // Space between image and text
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6)) // Background for restaurant info
                                    .cornerRadius(12) // Rounded corners
                                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Subtle shadow
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal) // Horizontal padding for ScrollView
            }
        }
        .onAppear {
            // Fetch restaurant data when view appears
            Task {
                await viewModel.fetchRestaurants(ownerId: ownerId)
            }
        }
        .navigationTitle("My Restaurants") // Navigation title
    }
}
