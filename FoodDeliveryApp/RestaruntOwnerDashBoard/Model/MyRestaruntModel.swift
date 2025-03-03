//
//  MyRestrauntModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 29/11/24.
//

import Foundation
import SwiftUI
//// MARK: - Model
struct Restauranta: Identifiable, Decodable {
    let id: Int
    let ownerId: Int
    let name: String
    let phoneNumber: String
    let openingTime: String
    let closingTime: String
    let isActive: Bool
    let imageUrl: String?
}

struct RestaurantResponse: Decodable {
    let restaurants: [Restauranta]
}
