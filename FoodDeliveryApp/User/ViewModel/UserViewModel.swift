//
//  UserViewModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/11/24.
//
//import Foundation
//
//// MARK: - UserManager
//class UserManager: ObservableObject {
//    @Published var users: [User] = []
//    @Published var userId: Int? // Track logged-in user ID
//    @Published var role: String? // Track logged-in user's role
//    
//    private let registerURL = "http://localhost:5227/api/User/register"
//    private let loginURL = "http://localhost:5227/api/User/login"
//    
//    // MARK: - Register User
//    /// Registers a new user with the provided details.
//    func registerUser(name: String, email: String, password: String, phoneNumber: String, roleId: Int32) async -> Bool {
//        let newUser = User(id: 0, name: name, email: email, password: password, phoneNumber: phoneNumber, roleId: roleId)
//        
//        guard let url = URL(string: registerURL) else { return false }
//        
//        do {
//            let success = try await NetworkService.shared.postUser(url: url, user: newUser)
//            return success
//        } catch {
//            print("Failed to register user: \(error.localizedDescription)")
//            return false
//        }
//    }
//    
//    // MARK: - Login User
//    /// Logs in a user with the provided email and password.
//    func loginUser(email: String, password: String) async -> Bool {
//        guard let url = URL(string: loginURL) else { return false }
//        
//        do {
//            if let loginResponse = try await NetworkService.shared.postLogin(url: url, email: email, password: password) {
//                DispatchQueue.main.async {
//                    self.userId = loginResponse.userId
//                    self.role = loginResponse.role
//                    
//                }
//                return true
//            } else {
//                return false // Login failed
//            }
//        } catch {
//            print("Failed to login user: \(error.localizedDescription)")
//            return false
//        }
//    }
//    
//
//    
//    // MARK: - Logout User
//    /// Logs out the current user by clearing stored session data.
//    func logoutUser() {
//        userId = nil
//        role = nil
//        // Additional session-specific cleanup can be performed here
//    }
//}
//


//



import Foundation

@MainActor
class UserManager: ObservableObject {
    @Published var users: [User] = []
    @Published var userId: Int? // Track logged-in user ID
    @Published var role: String? // Track logged-in user's role

    private let registerURL = "http://localhost:5227/api/User/register"
    private let loginURL = "http://localhost:5227/api/User/login"

    // MARK: - Register User
    /// Registers a new user with the provided details.
    func registerUser(name: String, email: String, password: String, phoneNumber: String, roleId: Int32) async -> Bool {
        // Validate input
        guard validateEmail(email), validatePassword(password) else {
            print("Invalid email or password.")
            return false
        }

        let newUser = User(id: 0, name: name, email: email, password: password, phoneNumber: phoneNumber, roleId: roleId)

        guard let url = URL(string: registerURL) else {
            print("Invalid register URL.")
            return false
        }

        do {
            let success = try await NetworkService.shared.postUser(url: url, user: newUser)
            return success
        } catch {
            print("Failed to register user: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Login User
    /// Logs in a user with the provided email and password.
    func loginUser(email: String, password: String) async -> Bool {
        // Validate input
        guard validateEmail(email), !password.isEmpty else {
            print("Invalid email or password.")
            return false
        }

        guard let url = URL(string: loginURL) else {
            print("Invalid login URL.")
            return false
        }

        do {
            if let loginResponse = try await NetworkService.shared.postLogin(url: url, email: email, password: password) {
                self.userId = loginResponse.userId
                self.role = loginResponse.role
                return true
            } else {
                print("Login failed.")
                return false
            }
        } catch {
            print("Failed to login user: \(error.localizedDescription)")
            return false
        }
    }

    
    
    
    
    
    // MARK: - Logout User
    /// Logs out the current user by clearing stored session data.
    func logoutUser() {
        userId = nil
        role = nil
        // Perform additional session-specific cleanup if needed
    }

    // MARK: - Helper Methods
    /// Validates an email address using a regular expression.
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    /// Validates a password based on specific criteria (e.g., minimum length).
    private func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
