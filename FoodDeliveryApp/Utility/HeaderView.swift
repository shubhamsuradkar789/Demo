//
//  HeaderView.swift
//  FoodDeliveryApp
//
//  Created by Shubham Suradkar on 14/11/24.
//

import SwiftUI

// MARK: - HeaderView
// A custom header view with a blue background
var headerView: some View {
    ZStack {
        Color.blue
            .frame(height: 100) // Header height
            .edgesIgnoringSafeArea(.top) // Extends background to top edges
    }
}


