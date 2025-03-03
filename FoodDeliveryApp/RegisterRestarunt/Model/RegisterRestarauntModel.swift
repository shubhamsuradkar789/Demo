//
//  RegisterRestarauntModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 29/11/24.
//

import Foundation


// MARK: - RestaurantRegistration Model
struct RestaurantRegistration: Codable {
    var ownerId: Int
    var name: String
    var phoneNumber: String
    var rating: Double?
    var openingTime: String
    var closingTime: String
    var image_url: String?
    var streetAddress: String
    var additionalAddress: String
    var city: String
    var state: String
    var pincode: String

    // Coding keys to match API expectations
    enum CodingKeys: String, CodingKey {
        case ownerId
        case name
        case phoneNumber
        case rating
        case openingTime = "opening_time"
        case closingTime = "closing_time"
        case image_url
        case streetAddress
        case additionalAddress
        case city
        case state
        case pincode
    }
}
