//
//  RestaruntViewModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 14/11/24.
//

import Foundation

// MARK: - ViewModel for Restaurant Data Handling
class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""  // Holds text input for search

    // MARK: Filtered Restaurants
    // Returns restaurants matching the search text, or all if search text is empty
    var filteredRestaurants: [Restaurant] {
        if searchText.isEmpty {
            return restaurants
        } else {
            return restaurants.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    // MARK: Fetch Restaurants
    // Initiates network request to retrieve restaurant data
    func fetchRestaurants() {
        guard let url = URL(string: "http://localhost:5227/api/Restaurant/get-all-restaurants") else { return }
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                // Handle network error if present
                if let error = error {
                    self.errorMessage = "Failed to load data: \(error.localizedDescription)"
                    return
                }
                
                // Validate received data
                guard let data = data else {
                    self.errorMessage = "No data found"
                    return
                }
                
                // Decode JSON response to Restaurant objects
                do {
                    let decodedData = try JSONDecoder().decode([String: [Restaurant]].self, from: data)
                    self.restaurants = decodedData["restaurants"] ?? []
                } catch {
                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
