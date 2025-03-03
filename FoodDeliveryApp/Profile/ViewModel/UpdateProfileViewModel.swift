//
//  ProfileViewModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/11/24.
//
//
//import Foundation
////
////// MARK: - ProfileViewModel
//class ProfileViewModel: ObservableObject {
//    @Published var userProfile: UserProfile
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    @Published var successMessage: String? // Success message for UI feedback
//
//    init(userProfile: UserProfile) {
//        self.userProfile = userProfile
//    }
//
//    // MARK: - Validation Functions
//    private func isValidEmail(_ email: String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailPred.evaluate(with: email)
//    }
//    
//    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
//        let phoneRegEx = "^[0-9]{10}$"
//        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
//        return phonePred.evaluate(with: phoneNumber)
//    }
//    
//    private func isValidPassword(_ password: String) -> Bool {
//        return password.count >= 7
//    }
//    
//    private func validateFields() -> Bool {
//        if userProfile.name.isEmpty || userProfile.email.isEmpty || userProfile.password.isEmpty || userProfile.phoneNumber.isEmpty {
//            errorMessage = "All fields are required."
//            return false
//        }
//        
//        if !isValidEmail(userProfile.email) {
//            errorMessage = "Invalid email format."
//            return false
//        }
//        
//        if !isValidPassword(userProfile.password) {
//            errorMessage = "Password must be at least 7 characters."
//            return false
//        }
//        
//        if !isValidPhoneNumber(userProfile.phoneNumber) {
//            errorMessage = "Phone number must be 10 digits."
//            return false
//        }
//        
//        errorMessage = nil // Clear any existing error if validations pass
//        return true
//    }
//
//    
//    func updateProfile() {
//        guard validateFields() else { return }
//
//        guard let url = URL(string: "http://localhost:5227/api/User/\(userProfile.userId)/update-profile") else {
//            self.errorMessage = "Invalid URL"
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "PATCH"  // Change the method to PATCH instead of PUT
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let updateProfileData = UserProfile(
//            userId: userProfile.userId,
//            name: userProfile.name,
//            email: userProfile.email,
//            password: userProfile.password,
//            phoneNumber: userProfile.phoneNumber,
//            role: "" // Exclude the role field, if needed
//        )
//        
//        do {
//            let jsonData = try JSONEncoder().encode(updateProfileData)
//            request.httpBody = jsonData
//        } catch {
//            self.errorMessage = "Failed to encode user data"
//            return
//        }
//
//        self.isLoading = true
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                self.isLoading = false
//
//                // Handle network error
//                if let error = error {
//                    self.errorMessage = "Failed to update profile: \(error.localizedDescription)"
//                    self.successMessage = nil
//                    return
//                }
//
//                // Handle HTTP response status
//                if let response = response as? HTTPURLResponse {
//                    print("Status Code: \(response.statusCode)")  // Debugging status code
//                    if let headers = response.allHeaderFields as? [String: String] {
//                        print("Response Headers: \(headers)")  // Debugging headers
//                    }
//
//                    // If response is not 200, check the response body
//                    if response.statusCode == 200 {
//                        self.successMessage = "Profile updated successfully"
//                        self.errorMessage = nil
//                    } else {
//                        if let data = data, let responseBody = String(data: data, encoding: .utf8) {
//                            print("Response Body: \(responseBody)")  // More detailed response logging
//                        }
//                        self.errorMessage = "Failed to update profile. Email already in use."
//                        self.successMessage = nil
//                    }
//                }
//            }
//        }.resume()
//    }
//
//}
//
//



//


//

import Foundation
import SwiftUI

// MARK: - ProfileViewModel
class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    init(userProfile: UserProfile) {
        self.userProfile = userProfile
    }

    // MARK: - Fetch User Details by ID
//    func fetchUserDetails(userId: Int) async {
//        guard let url = URL(string: "http://localhost:5227/api/User/\(userId)") else {
//            self.errorMessage = "Invalid URL for fetching user details."
//            return
//        }
//
//        self.isLoading = true
//
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                let fetchedUser = try JSONDecoder().decode(UserProfile.self, from: data)
//                DispatchQueue.main.async {
//                    self.userProfile = fetchedUser
//                    self.isLoading = false
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Failed to fetch user details."
//                    self.isLoading = false
//                }
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = "Error: \(error.localizedDescription)"
//                self.isLoading = false
//            }
//        }
//    }

    
    func fetchUserDetails(userId: Int) async {
        guard let url = URL(string: "http://localhost:5227/api/User/\(userId)") else {
            self.errorMessage = "Invalid URL for fetching user details."
            return
        }

        self.isLoading = true

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            // Debugging: Log the raw response
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)") // Logs the raw response data
            }

            // Attempt to decode JSON
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let fetchedUser = try JSONDecoder().decode(UserProfile.self, from: data)
                DispatchQueue.main.async {
                    self.userProfile = fetchedUser
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch user details. Invalid response."
                    self.isLoading = false
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    
    
    
    
    // MARK: - Validate Profile Fields
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegEx = "^[0-9]{10}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phoneNumber)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 7
    }
    
    private func validateFields() -> Bool {
        if userProfile.name.isEmpty || userProfile.email.isEmpty || userProfile.password.isEmpty || userProfile.phoneNumber.isEmpty {
            errorMessage = "All fields are required."
            return false
        }
        
        if !isValidEmail(userProfile.email) {
            errorMessage = "Invalid email format."
            return false
        }
        
        if !isValidPassword(userProfile.password) {
            errorMessage = "Password must be at least 7 characters."
            return false
        }
        
        if !isValidPhoneNumber(userProfile.phoneNumber) {
            errorMessage = "Phone number must be 10 digits."
            return false
        }
        
        errorMessage = nil // Clear any existing error if validations pass
        return true
    }

    // MARK: - Update Profile
    func updateProfile() {
        guard validateFields() else { return }

        guard let url = URL(string: "http://localhost:5227/api/User/\(userProfile.userId)/update-profile") else {
            self.errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"  // Using PATCH for partial updates
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateProfileData = UserProfile(
            userId: userProfile.userId,
            name: userProfile.name,
            email: userProfile.email,
            password: userProfile.password,
            phoneNumber: userProfile.phoneNumber,
            role: "" // Optional: exclude role field if not needed
        )
        
        do {
            let jsonData = try JSONEncoder().encode(updateProfileData)
            request.httpBody = jsonData
        } catch {
            self.errorMessage = "Failed to encode user data"
            return
        }

        self.isLoading = true

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                // Handle network error
                if let error = error {
                    self.errorMessage = "Failed to update profile: \(error.localizedDescription)"
                    self.successMessage = nil
                    return
                }

                // Handle HTTP response status
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        self.successMessage = "Profile updated successfully"
                        self.errorMessage = nil
                    } else {
                        self.errorMessage = "Failed to update profile. Please try again."
                        self.successMessage = nil
                    }
                }
            }
        }.resume()
    }
}

// MARK: - UserProfile Model
//struct UserProfile: Codable {
//    var userId: Int
//    var name: String
//    var email: String
//    var password: String
//    var phoneNumber: String
//    var role: String?
//}

