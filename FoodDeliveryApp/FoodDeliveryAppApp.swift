//
//  FoodDeliveryAppApp.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 13/11/24.
//

import SwiftUI

@main
struct FoodDeliveryAppApp: App {
    @StateObject private var userManager = UserManager() // Initialize UserManager here

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager) // Inject UserManager as EnvironmentObject

            
        }
    }

}
