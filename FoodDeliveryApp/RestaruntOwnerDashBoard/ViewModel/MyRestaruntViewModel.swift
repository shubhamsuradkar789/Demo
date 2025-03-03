//
//  MyRestaruntViewModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 29/11/24.

//
//import Foundation
////
//// MARK: - ViewModel
//class MyRestaurantViewModel: ObservableObject {
//    @Published var restaurants: [Restauranta] = [] // List of restaurants
//    @Published var isLoading: Bool = false        // Loading state
//    @Published var errorMessage: String? = nil   // Error message
//
//    /// Fetch restaurants for the logged-in user
//    func fetchRestaurants(ownerId: Int) async {
//        DispatchQueue.main.sync {
//            isLoading = true
//            errorMessage = nil
//        }
////        isLoading = true
////        errorMessage = nil
//        
//        // Try fetching restaurants from the API
//        do {
//            let fetchedRestaurants = try await MyRestaurantViewModel.fetchRestaurantsFromAPI(ownerId: ownerId)
//            DispatchQueue.main.async {
//                self.restaurants = fetchedRestaurants
//                self.isLoading = false
//            }
//        } catch {
//            DispatchQueue.main.async {
//                // Handle error if fetching fails
//                self.errorMessage = "Failed to fetch restaurants. Please try again later."
//                self.isLoading = false
//            }
//        }
//    }
//
//    /// Networking code for fetching restaurants
//    private static func fetchRestaurantsFromAPI(ownerId: Int) async throws -> [Restauranta] {
//        let urlString = "http://localhost:5227/api/Restaurant/get-restaurants/\(ownerId)"
//        
//        // Ensure URL is valid
//        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
//
//        // Fetch data from API
//        let (data, response) = try await URLSession.shared.data(from: url)
//
//        // Ensure the response status code is 200 (OK)
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw URLError(.badServerResponse)
//        }
//
//        // Decode the JSON response into an array of restaurants
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601 // Use ISO 8601 for date parsing
//        return try decoder.decode(RestaurantResponse.self, from: data).restaurants
//    }
//}
////
//extension MyRestaurantViewModel {
//    /// Static function to format time from a date-time string or time-only string to "h:mm a"
//    static func formatTime(_ time: String) -> String {
//        let inputFormatter = DateFormatter()
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = "h:mm a" // Output format (e.g., "4:00 AM")
//
//        // Try parsing as ISO8601 date format first (e.g., "2000-01-01T04:00:00")
//        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        if let date = inputFormatter.date(from: time) {
//            return outputFormatter.string(from: date)
//        }
//
//        // If that fails, try parsing as "HH:mm:ss" format
//        inputFormatter.dateFormat = "HH:mm:ss"
//        if let date = inputFormatter.date(from: time) {
//            return outputFormatter.string(from: date)
//        }
//
//        // If parsing both formats fails, return the original string
//        return time
//    }
//}
//
//



import Foundation

// MARK: - ViewModel
@MainActor
class MyRestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restauranta] = [] // List of restaurants
    @Published var isLoading: Bool = false        // Loading state
    @Published var errorMessage: String? = nil   // Error message

    /// Fetch restaurants for the logged-in user
    func fetchRestaurants(ownerId: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            // Try fetching restaurants from the API
            let fetchedRestaurants = try await MyRestaurantViewModel.fetchRestaurantsFromAPI(ownerId: ownerId)
            restaurants = fetchedRestaurants
        } catch let error as URLError {
            // Handle URL-related errors
            errorMessage = "Network error: \(error.localizedDescription)"
        } catch let error as DecodingError {
            // Handle JSON decoding errors
            errorMessage = "Data error: \(error.localizedDescription)"
        } catch {
            // Handle other errors
            errorMessage = "An unexpected error occurred. Please try again later."
        }
        
        isLoading = false
    }

    /// Networking code for fetching restaurants
    private static func fetchRestaurantsFromAPI(ownerId: Int) async throws -> [Restauranta] {
        let urlString = "http://localhost:5227/api/Restaurant/get-restaurants/\(ownerId)"
        
        // Ensure URL is valid
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        // Fetch data from API
        let (data, response) = try await URLSession.shared.data(from: url)

        // Ensure the response status code is 200 (OK)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
        }

        // Decode the JSON response into an array of restaurants
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 // Use ISO 8601 for date parsing
            return try decoder.decode(RestaurantResponse.self, from: data).restaurants
        } catch {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Failed to decode response"))
        }
    }
}

// MARK: - Time Formatting Extension
extension MyRestaurantViewModel {
    /// Static function to format time from a date-time string or time-only string to "h:mm a"
    static func formatTime(_ time: String) -> String {
        let inputFormats = ["yyyy-MM-dd'T'HH:mm:ss", "HH:mm:ss"]
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a" // Output format (e.g., "4:00 AM")

        for format in inputFormats {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = format
            if let date = inputFormatter.date(from: time) {
                return outputFormatter.string(from: date)
            }
        }

        // If parsing all formats fails, return the original string
        return time
    }
}
