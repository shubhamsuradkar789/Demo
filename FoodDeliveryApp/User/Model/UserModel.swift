//
//  UserModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/11/24.
//

import Foundation

struct User: Identifiable, Codable {
    var id: Int
    var name: String
    var email: String
    var password: String
    var phoneNumber: String
    var roleId: Int32
}
