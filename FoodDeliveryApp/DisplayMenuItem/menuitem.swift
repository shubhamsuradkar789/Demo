//
//  menuitem.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 19/12/24.
//
import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct RestaurantMenuView: View {
    let restaurantId: Int
    let restaurantName: String

    @StateObject private var viewModel = MenuViewModel()
    @State private var cartItems: [CartItem] = []
    @State private var isCartViewPresented: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading menu...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if viewModel.menuItems.isEmpty {
                    Text("No menu items available.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.menuItems) { menuItem in
                                MenuItemRow(menuItem: menuItem, cartItems: $cartItems)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(restaurantName, displayMode: .inline)
            .navigationBarItems(leading: cartButton)
            .onAppear {
                viewModel.fetchMenuItems(for: restaurantId)
            }
            .sheet(isPresented: $isCartViewPresented) {
                CartView(cartItems: $cartItems)
            }
        }
    }

    private var cartButton: some View {
        HStack {
            Button(action: {
                isCartViewPresented.toggle()
            }) {
                HStack {
                    Image(systemName: "cart")
                        .font(.title2)

                    if !cartItems.isEmpty {
                        Text("\(cartItems.count)")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Circle().fill(Color.red))
                    }
                }
            }
        }
    }
}

//struct MenuItemRow: View {
//    let menuItem: MenuItem
//    @Binding var cartItems: [CartItem]
//
//    var body: some View {
//        HStack(spacing: 10) {
//            // Menu item image
//            if let imageUrl = menuItem.imageUrl, let url = URL(string: imageUrl) {
//                WebImage(url: url)
//                    .resizable()
//                    .indicator(.activity)
//                    .scaledToFill()
//                    .frame(width: 80, height: 80)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .shadow(radius: 4)
//            } else {
//                Image("placeholder") // Placeholder image
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 80, height: 80)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .shadow(radius: 4)
//            }
//
//            VStack(alignment: .leading, spacing: 8) {
//                Text(menuItem.name)
//                    .font(.headline)
//                    .lineLimit(1)
//
//                Text("$\(menuItem.price, specifier: "%.2f")")
//                    .font(.subheadline)
//                    .foregroundColor(.green)
//
//                if let description = menuItem.description {
//                    Text(description)
//                        .font(.footnote)
//                        .foregroundColor(.gray)
//                        .lineLimit(2)
//                }
//            }
//
//            Spacer()
//
//            HStack(spacing: 8) {
//                Button(action: {
//                    if let index = cartItems.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
//                        if cartItems[index].quantity > 1 {
//                            cartItems[index].quantity -= 1
//                        } else {
//                            cartItems.remove(at: index)
//                        }
//                    }
//                }) {
//                    Image(systemName: "minus.circle")
//                        .font(.title3)
//                        .foregroundColor(.red)
//                }
//
//                Text("\(cartItems.first(where: { $0.menuItem.id == menuItem.id })?.quantity ?? 0)")
//                    .font(.body)
//                    .frame(width: 30, alignment: .center)
//
//                Button(action: {
//                    if let index = cartItems.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
//                        cartItems[index].quantity += 1
//                    } else {
//                        cartItems.append(CartItem(menuItem: menuItem, quantity: 1))
//                    }
//                }) {
//                    Image(systemName: "plus.circle")
//                        .font(.title3)
//                        .foregroundColor(.blue)
//                }
//            }
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.white)
//                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
//        )
//        .padding(.horizontal, 8)
//    }
//}


struct MenuItemRow: View {
    let menuItem: MenuItem
    @Binding var cartItems: [CartItem]

    var body: some View {
        HStack(spacing: 10) {
            // Menu item image
            if let imageUrl = menuItem.imageUrl, let url = URL(string: imageUrl) {
                WebImage(url: url)
                    .resizable()
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 4)
            } else {
                Image("placeholder") // Placeholder image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 4)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(menuItem.name)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true) // Allows text to wrap

                Text("$\(menuItem.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.green)

                if let description = menuItem.description {
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true) // Allows text to wrap
                }
            }

            Spacer()

            HStack(spacing: 8) {
                Button(action: {
                    if let index = cartItems.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
                        if cartItems[index].quantity > 1 {
                            cartItems[index].quantity -= 1
                        } else {
                            cartItems.remove(at: index)
                        }
                    }
                }) {
                    Image(systemName: "minus.circle")
                        .font(.title3)
                        .foregroundColor(.red)
                }

                Text("\(cartItems.first(where: { $0.menuItem.id == menuItem.id })?.quantity ?? 0)")
                    .font(.body)
                    .frame(width: 30, alignment: .center)

                Button(action: {
                    if let index = cartItems.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
                        cartItems[index].quantity += 1
                    } else {
                        cartItems.append(CartItem(menuItem: menuItem, quantity: 1))
                    }
                }) {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 8)
    }
}


//struct MenuItemRow: View {
//    let menuItem: MenuItem
//    @Binding var cartItems: [CartItem]
//
//    var body: some View {
//        HStack(spacing: 10) {
//            // Menu item image
//            if let imageUrl = menuItem.imageUrl, let url = URL(string: imageUrl) {
//                WebImage(url: url)
//                    .resizable()
//                    .indicator(.activity)
//                    .scaledToFill()
//                    .frame(width: 80, height: 80)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .shadow(radius: 4)
//            } else {
//                Image("placeholder") // Placeholder image
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 80, height: 80)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .shadow(radius: 4)
//            }
//
//            VStack(alignment: .leading, spacing: 8) {
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(menuItem.name)
//                        .font(.headline)
//                        .fixedSize(horizontal: false, vertical: true) // Allows text to wrap
//
//                    Text("$\(menuItem.price, specifier: "%.2f")")
//                        .font(.subheadline)
//                        .foregroundColor(.green)
//
//                    if let description = menuItem.description {
//                        Text(description)
//                            .font(.footnote)
//                            .foregroundColor(.gray)
//                            .fixedSize(horizontal: false, vertical: true) // Allows text to wrap
//                    }
//                }
//
//                Spacer()
//
//                HStack(spacing: 8) {
//                    Button(action: {
//                        if let index = cartItems.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
//                            if cartItems[index].quantity > 1 {
//                                cartItems[index].quantity -= 1
//                            } else {
//                                cartItems.remove(at: index)
//                            }
//                        }
//                    }) {
//                        Image(systemName: "minus.circle")
//                            .font(.title3)
//                            .foregroundColor(.red)
//                    }
//
//                    Text("\(cartItems.first(where: { $0.menuItem.id == menuItem.id })?.quantity ?? 0)")
//                        .font(.body)
//                        .frame(width: 30, alignment: .center)
//
//                    Button(action: {
//                        if let index = cartItems.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
//                            cartItems[index].quantity += 1
//                        } else {
//                            cartItems.append(CartItem(menuItem: menuItem, quantity: 1))
//                        }
//                    }) {
//                        Image(systemName: "plus.circle")
//                            .font(.title3)
//                            .foregroundColor(.blue)
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.top, 10)
//            }
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.white)
//                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
//        )
//        .padding(.horizontal, 8)
//    }
//}




//struct MenuItemRow: View {
//    let menuItem: MenuItem
//    @Binding var cartItems: [CartItem]
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            // Menu item image
//            HStack(alignment: .top, spacing: 10) {
//                if let imageUrl = menuItem.imageUrl, let url = URL(string: imageUrl) {
//                    WebImage(url: url)
//                        .resizable()
//                        .indicator(.activity)
//                        .scaledToFill()
//                        .frame(width: 80, height: 80)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .shadow(radius: 4)
//                } else {
//                    Image("placeholder") // Placeholder image
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 80, height: 80)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .shadow(radius: 4)
//                }
//
//                VStack(alignment: .leading, spacing: 8) {
//                    Text(menuItem.name)
//                        .font(.headline)
//                        .fixedSize(horizontal: false, vertical: true) // Allows text to wrap
//
//                    Text("$\(menuItem.price, specifier: "%.2f")")
//                        .font(.subheadline)
//                        .foregroundColor(.green)
//
//                    if let description = menuItem.description {
//                        Text(description)
//                            .font(.footnote)
//                            .foregroundColor(.gray)
//                            .fixedSize(horizontal: false, vertical: true) // Allows text to wrap
//                    }
//                }
//            }
//
//            // Buttons aligned at the bottom-left
//            HStack(spacing: 8) {
//                Button(action: {
//                    if let index = cartItems.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
//                        if cartItems[index].quantity > 1 {
//                            cartItems[index].quantity -= 1
//                        } else {
//                            cartItems.remove(at: index)
//                        }
//                    }
//                }) {
//                    Image(systemName: "minus.circle")
//                        .font(.title3)
//                        .foregroundColor(.red)
//                }
//
//                Text("\(cartItems.first(where: { $0.menuItem.id == menuItem.id })?.quantity ?? 0)")
//                    .font(.body)
//                    .frame(width: 30, alignment: .center)
//
//                Button(action: {
//                    if let index = cartItems.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
//                        cartItems[index].quantity += 1
//                    } else {
//                        cartItems.append(CartItem(menuItem: menuItem, quantity: 1))
//                    }
//                }) {
//                    Image(systemName: "plus.circle")
//                        .font(.title3)
//                        .foregroundColor(.blue)
//                }
//            }
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.white)
//                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
//        )
//        .padding(.horizontal, 8)
//    }
//}



struct CartView: View {
    @Binding var cartItems: [CartItem]

    var body: some View {
        NavigationView {
            VStack {
                if cartItems.isEmpty {
                    Text("Your cart is empty!")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(cartItems) { item in
                        HStack {
                            Text(item.menuItem.name)
                                .font(.headline)

                            Spacer()

                            Text("Qty: \(item.quantity)")
                                .font(.subheadline)

                            Text("$\(Double(item.quantity) * item.menuItem.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationBarTitle("Cart", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        // Dismiss the view
                    }
                }
            }
        }
    }
}

class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func fetchMenuItems(for restaurantId: Int) {
        guard let url = URL(string: "http://localhost:5227/api/FoodItem/GetListofmenuItemByRestaurant/\(restaurantId)") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Failed to load menu items: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    self.menuItems = try JSONDecoder().decode([MenuItem].self, from: data)
                } catch {
//                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    self.errorMessage = "No Menu Item Added"
                }
            }
        }.resume()
    }
}

struct MenuItem: Identifiable, Decodable {
    let id: Int
    let name: String
    let price: Double
    let description: String?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, name, price, description
        case imageUrl = "image_url"
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let menuItem: MenuItem
    var quantity: Int
}






//





//
//import SwiftUI
//import Foundation
//import SDWebImageSwiftUI
//
//struct RestaurantMenuView: View {
//    let restaurantId: Int
//    let restaurantName: String
//
//    @StateObject private var viewModel = MenuViewModel()
//    @State private var cartItems: [CartItem] = []
//    @State private var isCartViewPresented: Bool = false
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if viewModel.isLoading {
//                    ProgressView("Loading menu...")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                } else if let errorMessage = viewModel.errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .padding()
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                } else if viewModel.menuItems.isEmpty {
//                    Text("No menu items available.")
//                        .foregroundColor(.gray)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                } else {
//                    ScrollView {
//                        LazyVStack(spacing: 10) {
//                            ForEach(viewModel.menuItems) { menuItem in
//                                MenuItemRow(menuItem: menuItem, cartItems: $cartItems)
//                                    .padding(.horizontal)
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle(restaurantName, displayMode: .inline)
//            .navigationBarItems(leading: cartButton)
//            .onAppear {
//                viewModel.fetchMenuItems(for: restaurantId)
//                cartItems = viewModel.loadCartItems()
//            }
//            .onChange(of: cartItems) { newValue in
//                viewModel.saveCartItems(cartItems: newValue)
//            }
//            .sheet(isPresented: $isCartViewPresented) {
//                CartView(cartItems: $cartItems)
//            }
//        }
//    }
//
//    private var cartButton: some View {
//        HStack {
//            Button(action: {
//                isCartViewPresented.toggle()
//            }) {
//                HStack {
//                    Image(systemName: "cart")
//                        .font(.title2)
//
//                    if !cartItems.isEmpty {
//                        Text("\(cartItems.count)")
//                            .font(.footnote)
//                            .foregroundColor(.white)
//                            .padding(6)
//                            .background(Circle().fill(Color.red))
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct MenuItemRow: View {
//    let menuItem: MenuItem
//    @Binding var cartItems: [CartItem]
//
//    var body: some View {
//        HStack(spacing: 10) {
//            if let imageUrl = menuItem.imageUrl, let url = URL(string: imageUrl) {
//                WebImage(url: url)
//                    .resizable()
//                    .indicator(.activity)
//                    .scaledToFill()
//                    .frame(width: 80, height: 80)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .shadow(radius: 4)
//            } else {
//                Image("placeholder")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 80, height: 80)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .shadow(radius: 4)
//            }
//
//            VStack(alignment: .leading, spacing: 8) {
//                Text(menuItem.name)
//                    .font(.headline)
//                    .lineLimit(1)
//
//                Text("$\(menuItem.price, specifier: "%.2f")")
//                    .font(.subheadline)
//                    .foregroundColor(.green)
//
//                if let description = menuItem.description {
//                    Text(description)
//                        .font(.footnote)
//                        .foregroundColor(.gray)
//                        .lineLimit(2)
//                }
//            }
//
//            Spacer()
//
//            HStack(spacing: 8) {
//                Button(action: {
//                    if let index = cartItems.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
//                        if cartItems[index].quantity > 1 {
//                            cartItems[index].quantity -= 1
//                        } else {
//                            cartItems.remove(at: index)
//                        }
//                    }
//                }) {
//                    Image(systemName: "minus.circle")
//                        .font(.title3)
//                        .foregroundColor(.red)
//                }
//
//                Text("\(cartItems.first(where: { $0.menuItem.id == menuItem.id })?.quantity ?? 0)")
//                    .font(.body)
//                    .frame(width: 30, alignment: .center)
//
//                Button(action: {
//                    if let index = cartItems.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
//                        cartItems[index].quantity += 1
//                    } else {
//                        cartItems.append(CartItem(menuItem: menuItem, quantity: 1))
//                    }
//                }) {
//                    Image(systemName: "plus.circle")
//                        .font(.title3)
//                        .foregroundColor(.blue)
//                }
//            }
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.white)
//                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
//        )
//        .padding(.horizontal, 8)
//    }
//}
//
//struct CartView: View {
//    @Binding var cartItems: [CartItem]
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if cartItems.isEmpty {
//                    Text("Your cart is empty!")
//                        .font(.title)
//                        .foregroundColor(.gray)
//                        .padding()
//                } else {
//                    List(cartItems) { item in
//                        HStack {
//                            Text(item.menuItem.name)
//                                .font(.headline)
//
//                            Spacer()
//
//                            Text("Qty: \(item.quantity)")
//                                .font(.subheadline)
//
//                            Text("$\(Double(item.quantity) * item.menuItem.price, specifier: "%.2f")")
//                                .font(.subheadline)
//                                .foregroundColor(.green)
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Cart", displayMode: .inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Close") {
//                        // Dismiss the view
//                    }
//                }
//            }
//        }
//    }
//}
//
//class MenuViewModel: ObservableObject {
//    @Published var menuItems: [MenuItem] = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String? = nil
//
//    private let cartKey = "userCartItems"
//
//    func fetchMenuItems(for restaurantId: Int) {
//        guard let url = URL(string: "http://localhost:5227/api/FoodItem/GetListofmenuItemByRestaurant/\(restaurantId)") else {
//            errorMessage = "Invalid URL"
//            return
//        }
//
//        isLoading = true
//        errorMessage = nil
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                self.isLoading = false
//
//                if let error = error {
//                    self.errorMessage = "Failed to load menu items: \(error.localizedDescription)"
//                    return
//                }
//
//                guard let data = data else {
//                    self.errorMessage = "No data received"
//                    return
//                }
//
//                do {
//                    self.menuItems = try JSONDecoder().decode([MenuItem].self, from: data)
//                } catch {
//                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
//                }
//            }
//        }.resume()
//    }
//
//    func saveCartItems(cartItems: [CartItem]) {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(cartItems) {
//            UserDefaults.standard.set(encoded, forKey: cartKey)
//        }
//    }
//
//    func loadCartItems() -> [CartItem] {
//        if let savedCartData = UserDefaults.standard.data(forKey: cartKey) {
//            let decoder = JSONDecoder()
//            if let decoded = try? decoder.decode([CartItem].self, from: savedCartData) {
//                return decoded
//            }
//        }
//        return []
//    }
//}
//
//struct MenuItem: Identifiable, Codable, Equatable {
//    let id: Int
//    let name: String
//    let price: Double
//    let description: String?
//    let imageUrl: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, price, description
//        case imageUrl = "image_url"
//    }
//
//    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
//        lhs.id == rhs.id
//    }
//}
//
//struct CartItem: Identifiable, Codable, Equatable {
//    let id: UUID
//    let menuItem: MenuItem
//    var quantity: Int
//
//    init(menuItem: MenuItem, quantity: Int) {
//        self.id = UUID()
//        self.menuItem = menuItem
//        self.quantity = quantity
//    }
//
//    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
//        lhs.id == rhs.id
//    }
//}
