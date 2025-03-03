//
//  RestaruntViews.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 14/11/24.
//

import Foundation

struct Restaurant: Identifiable, Decodable {
    var id: Int
    var ownerId: Int
    var name: String
    var phoneNumber: String
    var rating: Double?
    var openingTime: String
    var closingTime: String
    var isApproved: Bool
    var isActive: Bool
    var createdAt: String?
    var imageUrl: String?
    var cuisine: [String]

    // Map JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case id, ownerId, name, phoneNumber, rating, openingTime, closingTime, isApproved, isActive, createdAt, cuisine
        case imageUrl = "image_url"  // Maps JSON "image_url" to "imageUrl"
    }
}
