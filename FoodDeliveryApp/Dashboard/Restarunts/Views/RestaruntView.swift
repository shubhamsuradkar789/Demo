//
//  RestaruntView.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 14/11/24.
//
//
//import SwiftUI
//import SDWebImageSwiftUI
//
//struct RestaruntView: View {
//    @StateObject private var viewModel = RestaurantViewModel()
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                // Fixed Search Bar
//                HStack {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.gray)
//                    TextField("Search restaurants...", text: $viewModel.searchText)
//                        .padding(5)
//                        .background(Color.white)
//                        .cornerRadius(8)
//                }
//                .padding(10)
//                .background(Color.white)
//                .cornerRadius(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.black, lineWidth: 2)
//                )
//                .padding()
//
//                // Scrollable List of Restaurants
//                if viewModel.isLoading {
//                    ProgressView("Loading...")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                } else if let errorMessage = viewModel.errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .padding()
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                } else if viewModel.filteredRestaurants.isEmpty {
//                    Text("No restaurants found.")
//                        .foregroundColor(.gray)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                } else {
//                    ScrollView {
//                        LazyVStack(spacing: 0) {
//                            ForEach(viewModel.filteredRestaurants) { restaurant in
//                                RestaurantRow(restaurant: restaurant)
//                                    .padding(.horizontal)
//                                    .padding(.bottom, 8)
//                            }
//                        }
//                    }
//                }
//            }
////            .navigationBarTitle("Restaurants", displayMode: .inline)
//        }
//        .onAppear {
//            viewModel.fetchRestaurants()
//        }
//    }
//}
//
//struct RestaurantRow: View {
//    var restaurant: Restaurant
//
//    var body: some View {
//        HStack(alignment: .top) {  // Ensure top alignment of image and text
//            // Display restaurant image if available, else show placeholder
//            if let imageUrl = restaurant.imageUrl, let url = URL(string: imageUrl) {
//                WebImage(url: url)
//                    .resizable()
//                    .indicator(.activity)
//                    .scaledToFill()
//                    .frame(width: 110, height: 110)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//            } else {
//                Image("image2")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 110, height: 110)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//            }
//
//            VStack(alignment: .leading, spacing: 4) {  // Align text to the left
//                Text(restaurant.name)
//                    .font(.headline)
//                
//                Text("Cuisine: \(restaurant.cuisine.joined(separator: ", "))")
//                    .font(.subheadline)
//                    .foregroundColor(.black)
//                
//                Text("Phone: \(restaurant.phoneNumber)")
//                    .font(.subheadline)
//                    .foregroundColor(.black)
//                
//                // Dynamic star rating based on restaurant rating
//                HStack(spacing: 2) {
//                    ForEach(0..<5) { index in
//                        let starType = getStarType(for: index, rating: restaurant.rating ?? 0)
//                        Image(systemName: starType)
//                            .foregroundColor(.blue)
//                            .font(.system(size: 14))
//                    }
//                }
//            }
//            .padding(.leading, 8)  // Adjust this to control the space between image and text
//        }
//        .padding(.vertical, 8)
//        .frame(maxWidth: .infinity, alignment: .leading)  // Ensure the HStack spans full width and aligns to the leading edge
//    }
//
//    // Determine star icon based on rating level
//    func getStarType(for index: Int, rating: Double) -> String {
//        let starPosition = Double(index + 1)
//        
//        if rating >= starPosition {
//            return "star.fill"  // Full star
//        } else if rating >= starPosition - 0.75 && rating < starPosition - 0.25 {
//            return "star.leadinghalf.filled"  // Half-filled star
//        } else {
//            return "star"  // Empty star
//        }
//    }
//}




import SwiftUI
import SDWebImageSwiftUI

struct RestaruntView: View {
    @StateObject private var viewModel = RestaurantViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search restaurants...", text: $viewModel.searchText)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 2)
                )
                .padding()

                // Restaurant List or Messages
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if viewModel.filteredRestaurants.isEmpty {
                    Text("No restaurants found.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.filteredRestaurants) { restaurant in
                                NavigationLink(destination: RestaurantMenuView(restaurantId: restaurant.id, restaurantName: restaurant.name)) {
                                    RestaurantRow(restaurant: restaurant)
                                        .padding(.horizontal)
                                        .padding(.bottom, 8)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Restaurants", displayMode: .inline)
            .onAppear {
                viewModel.fetchRestaurants()
            }
        }
    }
}

struct RestaurantRow: View {
    var restaurant: Restaurant

    var body: some View {
        HStack(alignment: .top) {
            if let imageUrl = restaurant.imageUrl, let url = URL(string: imageUrl) {
                WebImage(url: url)
                    .resizable()
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image("placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.headline)
                
                Text("Cuisine: \(restaurant.cuisine.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                Text("Phone: \(restaurant.phoneNumber)")
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        let starType = getStarType(for: index, rating: restaurant.rating ?? 0)
                        Image(systemName: starType)
                            .foregroundColor(.blue)
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func getStarType(for index: Int, rating: Double) -> String {
        let starPosition = Double(index + 1)
        
        if rating >= starPosition {
            return "star.fill"
        } else if rating >= starPosition - 0.75 && rating < starPosition - 0.25 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}
