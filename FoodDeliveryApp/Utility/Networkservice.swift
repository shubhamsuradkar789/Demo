//
//  Networkservice.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 14/11/24.
//
import Foundation

// MARK: - NetworkService Singleton
class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    // MARK: - JWT Decoding
    /// Decode JWT token to extract `userId` and `role`.
    private func decodeJWT(_ token: String) -> (userId: Int?, role: String?) {
        let segments = token.split(separator: ".")
        guard segments.count > 1 else { return (nil, nil) }
        
        let base64String = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let paddedLength = base64String.count + (4 - base64String.count % 4) % 4
        let paddedBase64String = base64String.padding(toLength: paddedLength, withPad: "=", startingAt: 0)
        
        guard let data = Data(base64Encoded: paddedBase64String),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let userIdString = json["sub"] as? String,
              let userId = Int(userIdString),
              let role = json["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"] as? String else {
            return (nil, nil)
        }
        
        return (userId, role)
    }
    
    // MARK: - User Registration
    /// Send POST request for user registration.
    func postUser(url: URL, user: User) async throws -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(user)
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - User Login
    /// Send POST request for user login.
    func postLogin(url: URL, email: String, password: String) async throws -> (userId: Int?, role: String?)? {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginPayload = ["email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: loginPayload, options: [])
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            let decoder = JSONDecoder()
            if let responseObject = try? decoder.decode([String: String].self, from: data),
               let token = responseObject["token"] {
                return decodeJWT(token)
            }
        }
        
        return nil
    }
    
    // MARK: - Add Address
    /// Send POST request to add an address.
    func postAddress(url: URL, address: Address) async throws -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(address)
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Fetch Addresses
    /// Send GET request to fetch addresses.
    func getAddresses(url: URL) async throws -> [Address] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let addresses = try JSONDecoder().decode([Address].self, from: data)
        return addresses
    }
    
    // MARK: - Delete Address
    /// Send DELETE request to remove an address by its ID.
    func deleteAddress(id: Int) async throws -> Bool {
        let deleteAddressURL = "http://localhost:5227/api/User/delete-Address/\(id)"
        guard let url = URL(string: deleteAddressURL) else { return false }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Update Address
    /// Send PUT request to update an address.
    func updateAddress(url: URL, address: Address) async throws -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(address)
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            return true
        } else {
            return false
        }
    }
}
extension NetworkService {
    func registerRestaurantWithImage(url: URL, restaurant: RestaurantRegistration, imageData: Data?) async throws -> Bool {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add text fields
        let fields: [String: String] = [
            "ownerId": String(restaurant.ownerId),
            "name": restaurant.name,
            "phoneNumber": restaurant.phoneNumber,
            "streetAddress": restaurant.streetAddress,
            "additionalAddress": restaurant.additionalAddress,
            "openingTime": restaurant.openingTime,
            "closingTime": restaurant.closingTime,
            "city": restaurant.city,
            "state": restaurant.state,
            "pincode": restaurant.pincode,
            "image_url": restaurant.image_url ?? "" // Optional field
        ]
        for (key, value) in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        // Add image file if provided
        if let imageData = imageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"restaurant.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        } else {
            // Add empty placeholder for image
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            body.append(Data()) // Empty data
            body.append("\r\n".data(using: .utf8)!)
        }

        // Add closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // Send request
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")

            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                return true
            } else {
                if let responseBody = String(data: data, encoding: .utf8) {
                    print("Response Body: \(responseBody)")
                }
                return false
            }
        }
        return false
    }
}

import Foundation

extension NetworkService {
    func registerRestaurantWithImage(url: URL, menuItem: AddMenuItemRequest, imageData: Data?) async throws -> Bool {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add text fields
        let fields: [String: String] = [
            "name": menuItem.name,
            "description": menuItem.description,
            "cuisineTypeId": String(menuItem.cuisineTypeId),
            "price": String(menuItem.price),
            "categoryId": String(menuItem.categoryId),
            "isAvailable": String(menuItem.isAvailable)
        ]
        for (key, value) in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        // Add image file if available
        if let imageData = imageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"menuitem.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        // Add closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // Perform the request
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")

            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                return true
            } else {
                if let responseBody = String(data: data, encoding: .utf8) {
                    print("Response Body: \(responseBody)")
                }
                return false
            }
        }
        return false
    }
}
