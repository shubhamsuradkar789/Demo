//
//  AddressView.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/11/24.
//
import Foundation
import SwiftUI

// MARK: - AddressView
struct AddressView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject private var viewModel: AddressViewModel
    @State private var showAddAddressSheet = false
    @State private var showEditAddressSheet = false
    @State private var selectedAddress: Address?

    init(userManager: UserManager) {
        _viewModel = StateObject(wrappedValue: AddressViewModel(userManager: userManager))
    }

    var body: some View {
        VStack {
            // MARK: Add Address Button
            HStack {
                Spacer()
                Button(action: {
                    viewModel.clearAddressFields()
                    viewModel.message = ""
                    viewModel.showMessage = false
                    showAddAddressSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Address")
                    }
                    .foregroundColor(.red)
                    .font(.title3)
                    .padding()
                }
            }
            
            if !viewModel.addresses.isEmpty {
                Text("SAVED ADDRESSES")
                    .font(.title2)
                    .padding(20)
            }

            // MARK: Address List
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.addresses, id: \.id) { address in
                        AddressRowView(address: address, viewModel: viewModel, onEdit: {
                            selectedAddress = address
                            viewModel.loadAddressForEditing(address: address)
                            showEditAddressSheet = true
                        })
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                Task { await viewModel.fetchAddresses() }
            }
        }
        .sheet(isPresented: $showAddAddressSheet) {
            AddAddressSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $showEditAddressSheet) {
            if let selectedAddress = selectedAddress {
                EditAddressSheet(viewModel: viewModel, address: selectedAddress)
            }
        }
        .alert(isPresented: $viewModel.showMessage) {
            Alert(title: Text("Message"), message: Text(viewModel.message), dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: - AddressRowView
struct AddressRowView: View {
    let address: Address
    @ObservedObject var viewModel: AddressViewModel
    let onEdit: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(address.addressLine1)
                Text(address.addressLine2)
                Text("\(address.city), \(address.state), \(address.zipCode)")
                Text(address.country)
            }
            Spacer()
            
            // Delete button
            Button(action: {
                Task { await viewModel.deleteAddress(id: address.id) }
            }) {
                Image(systemName: "trash").foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())

            // Edit button
            Button(action: onEdit) {
                Image(systemName: "pencil").foregroundColor(.blue)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - AddAddressSheet
struct AddAddressSheet: View {
    @ObservedObject var viewModel: AddressViewModel
    @Environment(\.dismiss) var dismiss

    @State private var fieldErrors = [String: Bool]()

    var body: some View {
        VStack {
            Text("Add Address").font(.largeTitle).padding()
            AddressFieldsView(viewModel: viewModel, fieldErrors: $fieldErrors)
            
            Button(action: {
                if validateFields() {
                    Task {
                        await viewModel.addAddress()
                        if viewModel.message == "Address added successfully!" {
                            dismiss()
                        }
                    }
                }
            }) {
                SubmitButtonView(title: "Submit")
            }
            
            if viewModel.showMessage {
                Text(viewModel.message)
                    .foregroundColor(viewModel.message == "Address added successfully!" ? .green : .red)
                    .bold()
                    .padding()
            }
        }
        .padding()
        .onAppear {
            viewModel.message = ""
            viewModel.showMessage = false
        }
    }

    func validateFields() -> Bool {
        fieldErrors["addressLine1"] = viewModel.addressLine1.isEmpty
        fieldErrors["addressLine2"] = viewModel.addressLine2.isEmpty
        fieldErrors["city"] = viewModel.city.isEmpty
        fieldErrors["state"] = viewModel.state.isEmpty
        fieldErrors["zipCode"] = viewModel.zipCode.isEmpty
        fieldErrors["country"] = viewModel.country.isEmpty
        return !fieldErrors.values.contains(true)
    }
}

// MARK: - EditAddressSheet
struct EditAddressSheet: View {
    @ObservedObject var viewModel: AddressViewModel
    let address: Address
    @Environment(\.dismiss) var dismiss
    @State private var fieldErrors = [String: Bool]()

    var body: some View {
        VStack {
            Text("Edit Address").font(.largeTitle).padding()
            AddressFieldsView(viewModel: viewModel, fieldErrors: $fieldErrors)

            Button(action: {
                if validateFields() {
                    Task {
                        await viewModel.updateAddress(id: address.id)
                        if viewModel.message == "Address updated successfully!" {
                            dismiss()
                        }
                    }
                }
            }) {
                SubmitButtonView(title: "Update")
            }
            
            if viewModel.showMessage {
                Text(viewModel.message)
                    .foregroundColor(viewModel.message == "Address updated successfully!" ? .green : .red)
                    .bold()
                    .padding()
            }
        }
        .padding()
        .onAppear {
            viewModel.message = ""
            viewModel.showMessage = false
        }
    }

    func validateFields() -> Bool {
        fieldErrors["addressLine1"] = viewModel.addressLine1.isEmpty
        fieldErrors["addressLine2"] = viewModel.addressLine2.isEmpty
        fieldErrors["city"] = viewModel.city.isEmpty
        fieldErrors["state"] = viewModel.state.isEmpty
        fieldErrors["zipCode"] = viewModel.zipCode.isEmpty
        fieldErrors["country"] = viewModel.country.isEmpty
        return !fieldErrors.values.contains(true)
    }
}

// MARK: - Custom Views

// Address Fields View to reuse between Add and Edit sheets
struct AddressFieldsView: View {
    @ObservedObject var viewModel: AddressViewModel
    @Binding var fieldErrors: [String: Bool]

    var body: some View {
        Group {
            CustomTextField(label: "Flat/House No/Floor/Building", text: $viewModel.addressLine1, showError: fieldErrors["addressLine1"] ?? false, errorMessage: "Address Line 1 is required")
            CustomTextField(label: "Street Address", text: $viewModel.addressLine2, showError: fieldErrors["addressLine2"] ?? false, errorMessage: "Address Line 2 is required")
            CustomTextField(label: "City", text: $viewModel.city, showError: fieldErrors["city"] ?? false, errorMessage: "City is required")
            CustomTextField(label: "State", text: $viewModel.state, showError: fieldErrors["state"] ?? false, errorMessage: "State is required")
            CustomTextField(label: "Zip Code", text: $viewModel.zipCode, showError: fieldErrors["zipCode"] ?? false, errorMessage: "Zip Code is required")
            CustomTextField(label: "Country", text: $viewModel.country, showError: fieldErrors["country"] ?? false, errorMessage: "Country is required")
        }
    }
}

// Reusable submit button view
struct SubmitButtonView: View {
    let title: String

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
    }
}

// MARK: - CustomTextField
struct CustomTextField: View {
    var label: String
    @Binding var text: String
    var showError: Bool
    var errorMessage: String

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).foregroundColor(.gray)
            TextField(showError ? errorMessage : "", text: $text)
                .focused($isFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 8)
                                .stroke(showError ? Color.red : (isFocused ? Color.black : Color.gray), lineWidth: isFocused ? 3 : 1))
                .foregroundColor(.primary)
        }
        .padding(.horizontal)
    }
}
