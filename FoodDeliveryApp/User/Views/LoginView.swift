//
//  LoginView.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/11/24.
//

import SwiftUI
//
// MARK: - LoginView
struct LoginView: View {
    
    @EnvironmentObject var userManager: UserManager // Access UserManager for authentication
    
    @State private var email = "yatis@gmail.com"
    @State private var password = "1234567"
    @State private var showMessage = false
    @State private var message = ""
    @State private var showHomeView = false // Controls modal presentation of HomeView
    @State private var isLoading = false // Controls loading state

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // MARK: Header Image
                    Image("img1")
                        .resizable()
                        .frame(width: geometry.size.width, height: geometry.size.width * 0.66)
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                    
                    // MARK: Slogan Text
                    Text("Bringing your hunger to happiness!")
                        .font(.title)
                    
                        .fontWeight(.semibold)
                        .foregroundColor(Color.orange)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity)
                    
                    // MARK: Login Form
                    VStack(spacing: 20) {
                       
                        
                        // MARK: Email Field
                        TextField("Email/Username", text: $email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                        
                        // MARK: Password Field
                        SecureField("Password", text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                        
                        // MARK: Login Button
                        Button(action: {
                            validateFields() // Validate fields before login attempt
                            if message.isEmpty { // Proceed if no validation errors
                                isLoading = true
                                Task {
                                    let success = await userManager.loginUser(email: email, password: password)
                                    isLoading = false
                                    message = success ? "Login successful!" : "Invalid credentials! Please try again."
                                    showMessage = true
                                    if success {
                                        showHomeView = true
                                    }
                                }
                            } else {
                                showMessage = true
                            }
                        }) {
                            if isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.5))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            } else {
                                Text("Login")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                        }
                        .disabled(isLoading) // Disable button while loading
                        
                        // MARK: Display Message
                        if showMessage {
                            Text(message)
                                .foregroundColor(message == "Login successful!" ? .green : .red)
                                .bold()
                                .frame(maxWidth: .infinity)
                        }
                        
                        // MARK: Sign Up Link
                        HStack {
                            NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)) {
                                Text("Don't have an account? Sign Up")
                                    .foregroundColor(.blue)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showHomeView) {
                HomeView() // Present HomeView as a full-screen modal
            }
        }
    }

    // MARK: - Validation Function
    /// Validates fields to ensure they are filled in
    func validateFields() {
        if email.isEmpty && password.isEmpty {
            message = "Please enter both username and password."
        } else if email.isEmpty {
            message = "Please enter your username."
        } else if password.isEmpty {
            message = "Please enter your password."
        } else {
            message = ""
        }
    }
}
