//
//  AddMenuItemModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/12/24.
//
import Foundation

struct Category: Identifiable, Codable, Hashable {
    let id: Int
    let categoryName: String
}

struct CuisineResponse: Codable {
    let cuisines: [Cuisine]
}

struct Cuisine: Identifiable, Codable, Hashable {
    let id: Int
    let cuisineName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "cuisineId"
        case cuisineName
    }
}

struct AddMenuItemRequest: Codable {
    let name: String
    let description: String
    let cuisineTypeId: Int
    let price: Double
    let categoryId: Int
    let isAvailable: Bool
    
    init(name: String, description: String, cuisineTypeId: Int, price: Double, categoryId: Int, isAvailable: Bool) {
        self.name = name
        self.description = description
        self.cuisineTypeId = cuisineTypeId
        self.price = price
        self.categoryId = categoryId
        self.isAvailable = isAvailable
    }
}
