//
//import Foundation
//
///// Represents a category for the menu item.
//struct Category: Identifiable, Codable, Hashable {
//    let id: Int
//    let categoryName: String
//}
//
//struct CuisineResponse: Codable {
//    let cuisines: [Cuisine]
//}
//
///// Represents a cuisine type.
//struct Cuisine: Identifiable, Codable, Hashable {
//    let id: Int
//    let cuisineName: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "cuisineId"
//        case cuisineName
//    }
//}
//
///// Represents the request payload for adding a menu item.
//struct AddMenuItemRequest: Codable {
//    let name: String
//    let description: String
//    let cuisineTypeId: Int
//    let price: Double
//    let categoryId: Int
//    let isAvailable: Bool
//
//    init(name: String, description: String, cuisineTypeId: Int, price: Double, categoryId: Int, isAvailable: Bool) {
//        self.name = name
//        self.description = description
//        self.cuisineTypeId = cuisineTypeId
//        self.price = price
//        self.categoryId = categoryId
//        self.isAvailable = isAvailable
//    }
//}
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
////            guard let selectedCategoryId = selectedCategory?.id else { return }
////            categoryId = selectedCategoryId
////
////            guard let selectedCuisineId = selectedCuisine?.id else { return }
////            cuisineTypeId = selectedCuisineId
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
//                    self.message = "Failed to add menu item. Please try again."
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
//import SwiftUI
//
//struct ToastView: View {
//    var message: String
//    var body: some View {
//        Text(message)
//            .foregroundColor(.green)
//            .font(.headline)
//            .bold()
//            .padding(.horizontal, 5)
//    }
//}
//
//struct ToastModifier: ViewModifier {
//    @Binding var isPresented: Bool
//    let message: String
//
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//            if isPresented {
//                VStack {
//                    Spacer()
//                    ToastView(message: message)
//                        .transition(.move(edge: .bottom).combined(with: .opacity))
//                        .animation(.easeInOut, value: isPresented)
//                        .padding(.bottom, 100) // Adjust position above the bottom
//                }
//            }
//        }
//    }
//}
//
//extension View {
//    func toast(isPresented: Binding<Bool>, message: String) -> some View {
//        self.modifier(ToastModifier(isPresented: isPresented, message: message))
//    }
//}
//
//
//
//import SwiftUI
//
//
//import SwiftUI
//
//struct AddMenuItemView: View {
//    let restaurantId: Int
//    let ownerId: Int
//    @StateObject private var viewModel = AddMenuItemViewModel()
//
//    var body: some View {
//        VStack(alignment: .center) {
//            Text("Add Menu Item")
//                .font(.title)
////               .padding(.top)
//
//            Form {
//                Section(header: Text("Menu Item Details")
//                    .font(.headline)
//                    .foregroundColor(.red)
//                    .bold()
//                ) {
//                    TextField("Name", text: $viewModel.name)
//                    TextField("Description", text: $viewModel.description)
//
//                    Picker("Cuisine", selection: $viewModel.selectedCuisine) {
//                        ForEach(viewModel.cuisines, id: \.id) { cuisine in
//                            Text(cuisine.cuisineName).tag(cuisine as Cuisine?)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//
//                    TextField("Price", value: $viewModel.price, formatter: NumberFormatter())
//
//                    Picker("Category", selection: $viewModel.selectedCategory) {
//                        ForEach(viewModel.categories, id: \.id) { category in
//                            Text(category.categoryName).tag(category as Category?)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//
//                    Toggle("Is Available", isOn: $viewModel.isAvailable)
//                }
//                
//            }
//            Button(action: {
//                Task {
//                    await viewModel.addMenuItem(restaurantId: restaurantId, ownerId: ownerId)
//                }
//            }) {
//                Text("Add Item")
//                    .bold()
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//        .padding()
//        .onAppear {
//            Task {
//                await viewModel.fetchCategories()
//                await viewModel.fetchCuisines()
//            }
//        }
//        .toast(isPresented: $viewModel.showToast, message: viewModel.message)
//    }
//}
//
//
//
//
