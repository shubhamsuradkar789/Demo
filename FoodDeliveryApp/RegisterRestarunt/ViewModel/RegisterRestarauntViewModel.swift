//
//  RegisterRestarauntViewModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 29/11/24.
//
//import Foundation
//
//// MARK: - ViewModel for Restaurant Registration
//class RestaurantRegistrationViewModel: ObservableObject {
//    @Published var name = ""
//    @Published var phoneNumber = ""
//    @Published var streetAddress = ""
//    @Published var additionalAddress = ""
//    @Published var city = ""
//    @Published var state = ""
//    @Published var pincode = ""
//    @Published var openingTime = "" // User input for opening time (e.g., 7am)
//    @Published var closingTime = "" // User input for closing time (e.g., 7pm)
//    @Published var showMessage = false
//    @Published var message = ""
//
//    private let registerRestaurantURL = "http://localhost:5227/api/Restaurant/Register"
//    private var ownerId: Int?
//
//    init(ownerId: Int?) {
//        self.ownerId = ownerId
//    }
//
//    // MARK: - Validation Logic
//    /// Validates the restaurant input fields
//    func validateFields() -> Bool {
//        if name.isEmpty {
//            message = "Restaurant name is required."
//            return false
//        }
//        if phoneNumber.isEmpty || !phoneNumber.isValidPhoneNumber() {
//            message = "Please enter a valid phone number."
//            return false
//        }
//        if streetAddress.isEmpty {
//            message = "Street address is required."
//            return false
//        }
//        if city.isEmpty {
//            message = "City is required."
//            return false
//        }
//        if state.isEmpty {
//            message = "State is required."
//            return false
//        }
//        if pincode.isEmpty || !pincode.isNumeric {
//            message = "Please enter a valid pincode."
//            return false
//        }
//        if openingTime.isEmpty || openingTime.toISO8601Time() == nil {
//            message = "Please enter a valid opening time (e.g., 7am)."
//            return false
//        }
//        if closingTime.isEmpty || closingTime.toISO8601Time() == nil {
//            message = "Please enter a valid closing time (e.g., 7pm)."
//            return false
//        }
//        return true
//    }
//
//    // MARK: - Register Restaurant with Optional Image
//    /// Registers the restaurant with the provided image data
//    func registerRestaurant(imageData: Data?) async {
//        guard validateFields() else {
//            DispatchQueue.main.async { self.showMessage = true }
//            return
//        }
//
//        guard let ownerId = ownerId else {
//            DispatchQueue.main.async {
//                self.message = "User is not logged in. Unable to fetch owner ID."
//                self.showMessage = true
//            }
//            return
//        }
//
//        let newRestaurant = RestaurantRegistration(
//            ownerId: ownerId,
//            name: name,
//            phoneNumber: phoneNumber,
//            rating: nil,
//            openingTime: openingTime.toISO8601Time()!,
//            closingTime: closingTime.toISO8601Time()!,
//            image_url: nil,
//            streetAddress: streetAddress,
//            additionalAddress: additionalAddress,
//            city: city,
//            state: state,
//            pincode: pincode
//        )
//
//        guard let url = URL(string: registerRestaurantURL) else {
//            DispatchQueue.main.async {
//                self.message = "Invalid URL."
//                self.showMessage = true
//            }
//            return
//        }
//
//        do {
//            let success = try await NetworkService.shared.registerRestaurantWithImage(url: url, restaurant: newRestaurant, imageData: imageData)
//            DispatchQueue.main.async {
//                self.message = success ? "Restaurant registered successfully!" : "Failed to register restaurant."
//                self.showMessage = true
//                if success { self.clearFields() }
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.message = "Error: \(error.localizedDescription)"
//                self.showMessage = true
//            }
//        }
//    }
//
//    // MARK: - Clear Fields
//    /// Clears all input fields
//    func clearFields() {
//        name = ""
//        phoneNumber = ""
//        streetAddress = ""
//        additionalAddress = ""
//        city = ""
//        state = ""
//        pincode = ""
//        openingTime = ""
//        closingTime = ""
//    }
//}
//
//// MARK: - String Extensions for Validation
//extension String {
//    /// Validates phone number (10-digit format)
//    func isValidPhoneNumber() -> Bool {
//        let phoneRegex = "^[0-9]{10}$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//        return phoneTest.evaluate(with: self)
//    }
//
//    /// Checks if string contains only numeric characters
//    var isNumeric: Bool {
//        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
//    }
//
//    /// Converts user-friendly time (e.g., 7am) to ISO8601 format
//    func toISO8601Time() -> String? {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hha" // Input format (e.g., 7am, 7pm)
//        formatter.amSymbol = "AM"
//        formatter.pmSymbol = "PM"
//
//        if let date = formatter.date(from: self.lowercased()) {
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Output format
//            return formatter.string(from: date)
//        }
//        return nil
//    }
//}



import Foundation

// MARK: - ViewModel for Restaurant Registration
@MainActor
class RestaurantRegistrationViewModel: ObservableObject {
    @Published var name = ""
    @Published var phoneNumber = ""
    @Published var streetAddress = ""
    @Published var additionalAddress = ""
    @Published var city = ""
    @Published var state = ""
    @Published var pincode = ""
    @Published var openingTime = "" // User input for opening time (e.g., 7am)
    @Published var closingTime = "" // User input for closing time (e.g., 7pm)
    @Published var showMessage = false
    @Published var message = ""

    private let registerRestaurantURL = "http://localhost:5227/api/Restaurant/Register"
    private var ownerId: Int?

    init(ownerId: Int?) {
        self.ownerId = ownerId
    }

    // MARK: - Validation Logic
    /// Validates the restaurant input fields
    private func validateFields() -> Bool {
        if name.isEmpty {
            setMessage("Restaurant name is required.")
            return false
        }
        if phoneNumber.isEmpty || !phoneNumber.isValidPhoneNumber() {
            setMessage("Please enter a valid phone number.")
            return false
        }
        if streetAddress.isEmpty {
            setMessage("Street address is required.")
            return false
        }
        if city.isEmpty {
            setMessage("City is required.")
            return false
        }
        if state.isEmpty {
            setMessage("State is required.")
            return false
        }
        if pincode.isEmpty || !pincode.isNumeric {
            setMessage("Please enter a valid pincode.")
            return false
        }
        if openingTime.isEmpty || openingTime.toISO8601Time() == nil {
            setMessage("Please enter a valid opening time (e.g., 7am).")
            return false
        }
        if closingTime.isEmpty || closingTime.toISO8601Time() == nil {
            setMessage("Please enter a valid closing time (e.g., 7pm).")
            return false
        }
        return true
    }

    // MARK: - Register Restaurant with Optional Image
    /// Registers the restaurant with the provided image data
    func registerRestaurant(imageData: Data?) async {
        guard validateFields() else { return }
        guard let ownerId = ownerId else {
            setMessage("User is not logged in. Unable to fetch owner ID.")
            return
        }

        guard let url = URL(string: registerRestaurantURL) else {
            setMessage("Invalid URL.")
            return
        }

        let newRestaurant = RestaurantRegistration(
            ownerId: ownerId,
            name: name,
            phoneNumber: phoneNumber,
            rating: nil,
            openingTime: openingTime.toISO8601Time()!,
            closingTime: closingTime.toISO8601Time()!,
            image_url: nil,
            streetAddress: streetAddress,
            additionalAddress: additionalAddress,
            city: city,
            state: state,
            pincode: pincode
        )

        do {
            let success = try await NetworkService.shared.registerRestaurantWithImage(url: url, restaurant: newRestaurant, imageData: imageData)
            setMessage(success ? "Restaurant registered successfully!" : "Failed to register restaurant.")
            if success { clearFields() }
        } catch {
            setMessage("Error: \(error.localizedDescription)")
        }
    }

    // MARK: - Set Message
    /// Sets the error or success message
    private func setMessage(_ text: String) {
        message = text
        showMessage = true
    }

    // MARK: - Clear Fields
    /// Clears all input fields
    private func clearFields() {
        name = ""
        phoneNumber = ""
        streetAddress = ""
        additionalAddress = ""
        city = ""
        state = ""
        pincode = ""
        openingTime = ""
        closingTime = ""
    }
}

// MARK: - String Extensions for Validation
extension String {
    /// Validates phone number (10-digit format)
    func isValidPhoneNumber() -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }

    /// Checks if string contains only numeric characters
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    /// Converts user-friendly time (e.g., 7am) to ISO8601 format
    func toISO8601Time() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "hha" // Input format (e.g., 7am, 7pm)
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        guard let date = formatter.date(from: self.lowercased()) else { return nil }
        formatter.dateFormat = "HH:mm:ss" // Output format
        return formatter.string(from: date)
    }
}
