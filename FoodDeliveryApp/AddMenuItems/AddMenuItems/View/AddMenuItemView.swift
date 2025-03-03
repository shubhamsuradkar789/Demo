//
//  AddMenuItemView.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/12/24.
//

import SwiftUI

struct AddMenuItemView: View {
    let restaurantId: Int
    let ownerId: Int
    @StateObject private var viewModel = AddMenuItemViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Add Menu Item")
                .font(.title)
            
            Form {
                Section(header: Text("Menu Item Details")
                    .font(.headline)
                    .foregroundColor(.red)
                    .bold()
                ) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                    
                    Picker("Cuisine", selection: $viewModel.selectedCuisine) {
                        ForEach(viewModel.cuisines, id: \.id) { cuisine in
                            Text(cuisine.cuisineName).tag(cuisine as Cuisine?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    TextField("Price", value: $viewModel.price, formatter: NumberFormatter())
                    
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.categories, id: \.id) { category in
                            Text(category.categoryName).tag(category as Category?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Toggle("Is Available", isOn: $viewModel.isAvailable)
                }
                Button(action: {
                    Task {
                        await viewModel.addMenuItem(restaurantId: restaurantId, ownerId: ownerId)
                    }
                }) {
                    Text("Add Item")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        
        .onAppear {
            Task {
                await viewModel.fetchCategories()
                await viewModel.fetchCuisines()
            }
        }
        .toast(isPresented: $viewModel.showToast, message: viewModel.message)
    }
}

import SwiftUI

struct ToastView: View {
    var message: String
    var body: some View {
        Text(message)
            .foregroundColor(.green)
            .font(.headline)
            .bold()
            .padding(.horizontal, 5)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    Spacer()
                    ToastView(message: message)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: isPresented)
                        .padding(.bottom, 150) // Adjust position above the bottom
                }
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}




