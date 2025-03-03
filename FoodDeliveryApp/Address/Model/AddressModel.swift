//
//  AddressModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/11/24.
//

import Foundation
// Address model
struct Address: Codable {
    var id: Int
    var entityId: Int
    var entityType: String
    var addressLine1: String
    var addressLine2: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
}
