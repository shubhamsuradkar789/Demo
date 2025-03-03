//
//  RegisterView.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/11/24.
//
import SwiftUI

// MARK: - RegisterView
struct RegisterView: View {
    @StateObject var userManager = UserManager()
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""
    @State private var selectedRoleId: Int32 = 1004 // Default role to "User"
    @State private var showMessage = false
    @State private var message = ""
    @Environment(\.presentationMode) var presentationMode // To navigate back

    let roles = [
        (id: Int32(1004), name: "User"),
        (id: Int32(1005), name: "Delivery Partner"),
        (id: Int32(1006), name: "Restaurant Owner")
    ]

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

                    // MARK: Registration Form
                    VStack(spacing: 10) {
                        // Name Field
                        TextField("Name", text: $name)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                            .padding(.horizontal)
                        
                        // Email Field
                        TextField("Email", text: $email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding(.horizontal)
                        
                        // Password Field
                        SecureField("Password", text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                            .padding(.horizontal)
                        
                        // Phone Number Field
                        TextField("Phone Number", text: $phoneNumber)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                            .keyboardType(.phonePad)
                            .padding(.horizontal)
                        
                        // Role Selection
                        Picker("Select Role", selection: $selectedRoleId) {
                            ForEach(roles, id: \.id) { role in
                                Text(role.name).tag(role.id)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                        
                        // MARK: Register Button
                        Button(action: {
                            if validateForm() {
                                Task {
                                    let success = await userManager.registerUser(
                                        name: name,
                                        email: email,
                                        password: password,
                                        phoneNumber: phoneNumber,
                                        roleId: selectedRoleId
                                    )
                                    message = success ? "Registration successful!" : "Email already exists or registration failed!"
                                    showMessage = true
                                    
                                    // Auto-dismiss on success
                                    if success {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            } else {
                                showMessage = true
                            }
                        }) {
                            Text("Register")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        
                        // Display message (success or failure)
                        if showMessage {
                            Text(message)
                                .foregroundColor(message == "Registration successful!" ? .green : .red)
                                .bold()
                                .frame(maxWidth: .infinity)
                        }
                        
                        // MARK: Login Navigation Link
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Already have an account? Login")
                                .foregroundColor(.blue)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Form Validation
    /// Validates the registration form fields.
    func validateForm() -> Bool {
        if name.isEmpty || email.isEmpty || password.isEmpty || phoneNumber.isEmpty {
            message = "All fields are required!"
            return false
        }
        if !isValidEmail(email) {
            message = "Invalid email format!"
            return false
        }
        if password.count < 7 {
            message = "Password must be at least 7 characters long!"
            return false
        }
        if !isValidPhoneNumber(phoneNumber) {
            message = "Invalid phone number! Must be 10 digits."
            return false
        }
        return true
    }
    
    // MARK: - Helper Functions
    /// Checks if the provided email is in a valid format.
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    /// Checks if the provided phone number is a valid 10-digit number.
    func isValidPhoneNumber(_ phone: String) -> Bool {
        let phoneRegEx = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: phone)
    }
}


