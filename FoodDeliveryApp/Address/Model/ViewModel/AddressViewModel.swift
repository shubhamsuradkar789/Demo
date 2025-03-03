//
//  AddressViewModel.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/11/24.
//
//import Foundation
//
//// MARK: - AddressViewModel
//class AddressViewModel: ObservableObject {
//    @Published var addressLine1 = ""
//    @Published var addressLine2 = ""
//    @Published var city = ""
//    @Published var state = ""
//    @Published var zipCode = ""
//    @Published var country = ""
//    @Published var addresses: [Address] = [] // Holds fetched addresses
//    @Published var showMessage = false
//    @Published var message = ""
//    
//    private let addAddressURL = "http://localhost:5227/api/User/add-Address"
//    private let updateAddressURL = "http://localhost:5227/api/User/update-address"
//    private var userManager: UserManager
//    
//    init(userManager: UserManager) {
//        self.userManager = userManager
//    }
//
//    // MARK: Load Address for Editing
//    /// Load address details into fields for editing.
//    func loadAddressForEditing(address: Address) {
//        addressLine1 = address.addressLine1
//        addressLine2 = address.addressLine2
//        city = address.city
//        state = address.state
//        zipCode = address.zipCode
//        country = address.country
//    }
//    
//    // MARK: Add Address
//    /// Add a new address with user details and refresh the address list.
//    func addAddress() async {
//        guard let url = URL(string: addAddressURL),
//              let userId = userManager.userId,
//              let entityType = userManager.role else {
//            DispatchQueue.main.async {
//                self.message = "User not logged in."
//                self.showMessage = true
//            }
//            return
//        }
//
//        let newAddress = Address(
//            id: 0,
//            entityId: userId,
//            entityType: entityType,
//            addressLine1: addressLine1,
//            addressLine2: addressLine2,
//            city: city,
//            state: state,
//            zipCode: zipCode,
//            country: country
//        )
//
//        do {
//            let success = try await NetworkService.shared.postAddress(url: url, address: newAddress)
//            DispatchQueue.main.async {
//                self.message = success ? "Address added successfully!" : "Failed to add address. Try again!"
//                if success {
//                    self.clearAddressFields()
//                }
//                self.showMessage = true
//            }
//            if success {
//                await fetchAddresses() // Refresh list after addition
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.message = "Failed to add address: \(error.localizedDescription)"
//                self.showMessage = true
//            }
//        }
//    }
//   
//    // MARK: Fetch Addresses
//    /// Fetch all addresses for the logged-in user.
////    func fetchAddresses() async {
////        guard let userId = userManager.userId, let role = userManager.role else {
////            DispatchQueue.main.async {
////                self.message = "User ID or role is missing."
////                self.showMessage = true
////            }
////            return
////        }
////        
////        let getAddressURL = "http://localhost:5227/api/User/get-address?userId=\(userId)&role=\(role)"
////        guard let url = URL(string: getAddressURL) else { return }
////        
////        do {
////            let fetchedAddresses = try await NetworkService.shared.getAddresses(url: url)
////            DispatchQueue.main.async {
////                self.addresses = fetchedAddresses
////            }
////        } catch {
////            DispatchQueue.main.async {
////                self.message = "Failed to fetch addresses: \(error.localizedDescription)"
////                self.showMessage = true
////            }
////        }
////    }
//    
//        func fetchAddresses() async {
//            guard let userId = userManager.userId, let role = userManager.role else {
//                DispatchQueue.main.async {
//                    self.message = "User ID or role is missing."
//                    self.showMessage = true
//                }
//                return
//            }
//    
//            let getAddressURL = "http://localhost:5227/api/User/get-address?userId=\(userId)&role=\(role)"
//            guard let url = URL(string: getAddressURL) else { return }
//    
//            do {
//                let fetchedAddresses = try await NetworkService.shared.getAddresses(url: url)
//                DispatchQueue.main.async {
//                    self.addresses = fetchedAddresses
//                }
//            } catch {
//                DispatchQueue.main.async {
//                                  self.message = "No addresses found. Please Add Address"
//                                  self.showMessage = true
//                }
//            }
//        }
//
//
//    // MARK: Delete Address
//    /// Delete an address by its ID and refresh the address list.
//    func deleteAddress(id: Int) async {
//        do {
//            let success = try await NetworkService.shared.deleteAddress(id: id)
//            DispatchQueue.main.async {
//                self.message = success ? "Address deleted successfully!" : "Failed to delete address."
//                self.showMessage = true
//            }
//            if success {
//                await fetchAddresses()
//                if addresses.isEmpty {
//                    DispatchQueue.main.async {
//                        self.message = "No addresses available. Please add a new address."
//                        self.showMessage = true
//                    }
//                }
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.message = "Failed to delete address: \(error.localizedDescription)"
//                self.showMessage = true
//            }
//        }
//    }
//
//    // MARK: Update Address
//    /// Update an existing address by ID and refresh the address list.
//    func updateAddress(id: Int) async {
//        guard let url = URL(string: "\(updateAddressURL)/\(id)") else {
//            DispatchQueue.main.async {
//                self.message = "Invalid URL."
//                self.showMessage = true
//            }
//            return
//        }
//
//        let updatedAddress = Address(
//            id: id,
//            entityId: userManager.userId ?? 0,
//            entityType: userManager.role ?? "User",
//            addressLine1: addressLine1,
//            addressLine2: addressLine2,
//            city: city,
//            state: state,
//            zipCode: zipCode,
//            country: country
//        )
//
//        do {
//            let success = try await NetworkService.shared.updateAddress(url: url, address: updatedAddress)
//            DispatchQueue.main.async {
//                self.message = success ? "Address updated successfully!" : "Failed to update address."
//                self.showMessage = true
//            }
//            if success {
//                await fetchAddresses()
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.message = "Failed to update address: \(error.localizedDescription)"
//                self.showMessage = true
//            }
//        }
//    }
//
//    // MARK: Clear Address Fields
//    /// Clear all address fields after adding an address.
//    func clearAddressFields() {
//        addressLine1 = ""
//        addressLine2 = ""
//        city = ""
//        state = ""
//        zipCode = ""
//        country = ""
//    }
//}



import Foundation

// MARK: - AddressViewModel
@MainActor
class AddressViewModel: ObservableObject {
    @Published var addressLine1 = ""
    @Published var addressLine2 = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zipCode = ""
    @Published var country = ""
    @Published var addresses: [Address] = [] // Holds fetched addresses
    @Published var showMessage = false
    @Published var message = ""
    
    private let baseURL = "http://localhost:5227/api/User"
    private var userManager: UserManager
    
    init(userManager: UserManager) {
        self.userManager = userManager
    }

    // MARK: - Load Address for Editing
    /// Load address details into fields for editing.
    func loadAddressForEditing(address: Address) {
        addressLine1 = address.addressLine1
        addressLine2 = address.addressLine2
        city = address.city
        state = address.state
        zipCode = address.zipCode
        country = address.country
    }
    
    // MARK: - Add Address
    /// Add a new address with user details and refresh the address list.
    func addAddress() async {
        guard let userId = userManager.userId, let role = userManager.role else {
            setMessage("User not logged in.")
            return
        }

        guard let url = URL(string: "\(baseURL)/add-Address") else {
            setMessage("Invalid URL.")
            return
        }

        let newAddress = Address(
            id: 0,
            entityId: userId,
            entityType: role,
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            city: city,
            state: state,
            zipCode: zipCode,
            country: country
        )

        do {
            let success = try await NetworkService.shared.postAddress(url: url, address: newAddress)
            setMessage(success ? "Address added successfully!" : "Failed to add address. Try again!")
            if success {
                clearAddressFields()
                await fetchAddresses() // Refresh list after addition
            }
        } catch {
            setMessage("Failed to add address: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch Addresses
    /// Fetch all addresses for the logged-in user.
    func fetchAddresses() async {
        guard let userId = userManager.userId, let role = userManager.role else {
            setMessage("User ID or role is missing.")
            return
        }

        guard let url = URL(string: "\(baseURL)/get-address?userId=\(userId)&role=\(role)") else {
            setMessage("Invalid URL.")
            return
        }

        do {
            let fetchedAddresses = try await NetworkService.shared.getAddresses(url: url)
            addresses = fetchedAddresses
            if addresses.isEmpty {
                setMessage("No addresses available. Please add a new address.")
            }
        } catch {
            setMessage("Failed to fetch addresses: \(error.localizedDescription)")
        }
    }

    // MARK: - Delete Address
    /// Delete an address by its ID and refresh the address list.
    func deleteAddress(id: Int) async {
        do {
            let success = try await NetworkService.shared.deleteAddress(id: id)
            setMessage(success ? "Address deleted successfully!" : "Failed to delete address.")
            if success {
                await fetchAddresses()
                if addresses.isEmpty {
                    setMessage("No addresses available. Please add a new address.")
                }
            }
        } catch {
            setMessage("Failed to delete address: \(error.localizedDescription)")
        }
    }

    // MARK: - Update Address
    /// Update an existing address by ID and refresh the address list.
    func updateAddress(id: Int) async {
        guard let url = URL(string: "\(baseURL)/update-address/\(id)") else {
            setMessage("Invalid URL.")
            return
        }

        let updatedAddress = Address(
            id: id,
            entityId: userManager.userId ?? 0,
            entityType: userManager.role ?? "User",
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            city: city,
            state: state,
            zipCode: zipCode,
            country: country
        )

        do {
            let success = try await NetworkService.shared.updateAddress(url: url, address: updatedAddress)
            setMessage(success ? "Address updated successfully!" : "Failed to update address.")
            if success {
                await fetchAddresses()
            }
        } catch {
            setMessage("Failed to update address: \(error.localizedDescription)")
        }
    }

    // MARK: - Clear Address Fields
    /// Clear all address fields after adding an address.
    func clearAddressFields() {
        addressLine1 = ""
        addressLine2 = ""
        city = ""
        state = ""
        zipCode = ""
        country = ""
    }

    // MARK: - Set Message
    /// Sets the message and shows the alert.
    private func setMessage(_ text: String) {
        message = text
        showMessage = true
    }
}
