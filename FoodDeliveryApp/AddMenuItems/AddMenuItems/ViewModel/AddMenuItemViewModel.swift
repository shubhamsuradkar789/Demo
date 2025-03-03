//
//  AddMenuItemViewModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/12/24.
//
//import Foundation
//
//class AddMenuItemViewModel: ObservableObject {
//    @Published var name: String = ""
//    @Published var description: String = ""
//    @Published var cuisineTypeId: Int = 0
//    @Published var price: Double = 0.0
//    @Published var categoryId: Int = 0
//    @Published var isAvailable: Bool = true
//    @Published var categories: [Category] = []
//    @Published var cuisines: [Cuisine] = []
//    @Published var selectedCategory: Category?
//    @Published var selectedCuisine: Cuisine?
//    @Published var message: String = "" // For the toast message
//    @Published var showToast: Bool = false // Controls visibility of the toast
//
//    func fetchCategories() async {
//        guard let url = URL(string: "http://localhost:5227/api/FoodItem/GetAllCategoriesList") else { return }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let decodedCategories = try JSONDecoder().decode([Category].self, from: data)
//            DispatchQueue.main.async {
//                self.categories = decodedCategories
//                self.selectedCategory = decodedCategories.first
//            }
//        } catch {
//            print("Error fetching categories: \(error.localizedDescription)")
//        }
//    }
//
//    func fetchCuisines() async {
//        guard let url = URL(string: "http://localhost:5227/api/Cuisine/get-all-cuisines") else { return }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let decodedResponse = try JSONDecoder().decode(CuisineResponse.self, from: data)
//            DispatchQueue.main.async {
//                self.cuisines = decodedResponse.cuisines
//                self.selectedCuisine = decodedResponse.cuisines.first
//            }
//        } catch {
//            print("Error fetching cuisines: \(error.localizedDescription)")
//        }
//    }
//
//    func addMenuItem(restaurantId: Int, ownerId: Int) async {
//        guard let url = URL(string: "http://localhost:5227/api/FoodItem/AddmenuItem/\(restaurantId)") else { return }
//
//        do {
//            DispatchQueue.main.async {
//                guard let selectedCategoryId = self.selectedCategory?.id else { return }
//                self.categoryId = selectedCategoryId
//
//                guard let selectedCuisineId = self.selectedCuisine?.id else { return }
//                self.cuisineTypeId = selectedCuisineId
//            }
//
//            let payload = createPayload()
//
//            let success = try await NetworkService.shared.registerRestaurantWithImage(url: url, menuItem: payload, imageData: nil)
//
//            DispatchQueue.main.async {
//                if success {
//                    self.message = "Menu item added successfully!"
//                    self.clearFields()
//                    self.showToastMessage()
//                } else {
////                    self.message = "Failed to add menu item. Please try again."
//                    self.message = "All Field Required."
//                    self.showToastMessage()
//                }
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.message = "Error adding menu item: \(error.localizedDescription)"
//                self.showToastMessage()
//            }
//        }
//    }
//
//    private func createPayload() -> AddMenuItemRequest {
//        return AddMenuItemRequest(
//            name: name,
//            description: description,
//            cuisineTypeId: cuisineTypeId,
//            price: price,
//            categoryId: categoryId,
//            isAvailable: isAvailable
//        )
//    }
//
//    private func clearFields() {
//        self.name = ""
//        self.description = ""
//        self.price = 0.0
//        self.selectedCategory = nil
//        self.selectedCuisine = nil
//        self.isAvailable = true
//    }
//
//    private func showToastMessage() {
//        self.showToast = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.showToast = false
//        }
//    }
//}





import Foundation

@MainActor
class AddMenuItemViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var cuisineTypeId: Int = 0
    @Published var price: Double = 0.0
    @Published var categoryId: Int = 0
    @Published var isAvailable: Bool = true
    @Published var categories: [Category] = []
    @Published var cuisines: [Cuisine] = []
    @Published var selectedCategory: Category?
    @Published var selectedCuisine: Cuisine?
    @Published var message: String = "" // For the toast message
    @Published var showToast: Bool = false // Controls visibility of the toast
    
    func fetchCategories() async {
        guard let url = URL(string: "http://localhost:5227/api/FoodItem/GetAllCategoriesList") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedCategories = try JSONDecoder().decode([Category].self, from: data)
            self.categories = decodedCategories
            self.selectedCategory = decodedCategories.first
        } catch {
            print("Error fetching categories: \(error.localizedDescription)")
        }
    }
    
    func fetchCuisines() async {
        guard let url = URL(string: "http://localhost:5227/api/Cuisine/get-all-cuisines") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(CuisineResponse.self, from: data)
            self.cuisines = decodedResponse.cuisines
            self.selectedCuisine = decodedResponse.cuisines.first
        } catch {
            print("Error fetching cuisines: \(error.localizedDescription)")
        }
    }
    
    func addMenuItem(restaurantId: Int, ownerId: Int) async {
        guard let url = URL(string: "http://localhost:5227/api/FoodItem/AddmenuItem/\(restaurantId)") else { return }
        
        do {
            guard let selectedCategoryId = self.selectedCategory?.id else {
                self.message = "Category is required."
                self.showToastMessage()
                return
            }
            self.categoryId = selectedCategoryId
            
            guard let selectedCuisineId = self.selectedCuisine?.id else {
                self.message = "Cuisine is required."
                self.showToastMessage()
                return
            }
            self.cuisineTypeId = selectedCuisineId
            
            let payload = createPayload()
            
            let success = try await NetworkService.shared.registerRestaurantWithImage(url: url, menuItem: payload, imageData: nil)
            
            if success {
                self.message = "Menu item added successfully!"
                self.clearFields()
                self.showToastMessage()
            } else {
                self.message = "Failed to add menu item. Please try again."
                self.showToastMessage()
            }
        } catch {
            self.message = "Error adding menu item: \(error.localizedDescription)"
            self.showToastMessage()
        }
    }
    
    private func createPayload() -> AddMenuItemRequest {
        return AddMenuItemRequest(
            name: name,
            description: description,
            cuisineTypeId: cuisineTypeId,
            price: price,
            categoryId: categoryId,
            isAvailable: isAvailable
        )
    }
    
    private func clearFields() {
        self.name = ""
        self.description = ""
        self.price = 0.0
        self.selectedCategory = nil
        self.selectedCuisine = nil
        self.isAvailable = true
    }
    
    private func showToastMessage() {
        self.showToast = true
        Task {
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
            self.showToast = false
        }
    }
}
