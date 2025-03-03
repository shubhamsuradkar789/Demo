//
//  ProfileView.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/11/24.
//
import SwiftUI
//
/// MARK: - ProfileView
struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @EnvironmentObject var userManager: UserManager  // Access logged-in user's info

    init() {
        // Initialize the view model with a placeholder UserProfile
        _viewModel = StateObject(wrappedValue: ProfileViewModel(userProfile: UserProfile(userId: 0, name: "", email: "", password: "", phoneNumber: "", role: "")))
    }

    var body: some View {
        VStack {
            // MARK: Welcome Message
            Text("Welcome to your profile!")
                .font(.title)
                .padding()

            // MARK: Profile Form
            Form {
                // Edit Profile Section
                Section(header: Text("Edit Profile")
                    .foregroundColor(.black)
                    .font(.headline)) {
                    
                    TextField("Name", text: $viewModel.userProfile.name)
                    TextField("Email", text: $viewModel.userProfile.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text: $viewModel.userProfile.password)
                    TextField("Phone Number", text: $viewModel.userProfile.phoneNumber)
                        .keyboardType(.phonePad)

                    // Role Display (Read-only)
                    Picker("Role", selection: $viewModel.userProfile.role) {
                        Text(viewModel.userProfile.role ?? "").tag(viewModel.userProfile.role)
                    }
                    .disabled(true)
                }

                // Save Changes Button
                Button(action: {
                    viewModel.updateProfile()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                // MARK: Messages
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }

                // Success Message
                if let successMessage = viewModel.successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
            }
        }
        .navigationTitle("Profile")
//        .onAppear {
//            // MARK: Initialize Profile Data
//            // Populate viewModel's userProfile with logged-in user info
//            if let userId = userManager.userId {
//                viewModel.userProfile.userId = userId
//                viewModel.userProfile.name = userManager.users.first { $0.id == userId }?.name ?? ""
//                viewModel.userProfile.email = userManager.users.first { $0.id == userId }?.email ?? ""
//                viewModel.userProfile.phoneNumber = userManager.users.first { $0.id == userId }?.phoneNumber ?? ""
//                viewModel.userProfile.role = userManager.role ?? ""
//            }
//        }
        
        .onAppear {
            
            Task {
                if let userId = userManager.userId {
                    await viewModel.fetchUserDetails(userId: userId)
                }
            }
        }

    }
}



//



//
