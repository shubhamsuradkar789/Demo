//
//  UpdateProfileModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/11/24.
//
//
import Foundation
//
//// MARK: - UserProfile Model
//struct UserProfile: Codable {
//    var userId: Int
//    var name: String
//    var email: String
//    var password: String
//    var phoneNumber: String
//    var role: String
//}


struct UserProfile: Codable {
    var userId: Int // Maps "id" from JSON
    var name: String
    var email: String
    var password: String // Maps "passwordHash" from JSON
    var phoneNumber: String
    var role: String? // Optional to handle `null` values

    enum CodingKeys: String, CodingKey {
        case userId = "id" // Maps "id" key in JSON to "userId"
        case name
        case email
        case password = "passwordHash" // Maps "passwordHash" key in JSON to "password"
        case phoneNumber
        case role
    }
}
