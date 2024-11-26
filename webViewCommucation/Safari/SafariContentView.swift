//
//  SafariContentView.swift
//  webViewCommucation
//
//  Created by ranjith kumar reddy b perkampally on 11/7/24.
//

import SwiftUI

struct SafariContentView: View {
    @Binding var accountNumber: String? // Binds to the app state
    
    var body: some View {
        VStack {
            Text("Welcome to Pay by Bank")
                .font(.largeTitle)
                .padding()
            
            if let accountNumber = accountNumber {
                Text("Account Number: \(accountNumber)")
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding()
            } else {
                Text("No Account Number Yet. Please click the below button to add an account number.")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Button to open Tink website in Safari
            Button("PBB in Safari") {
                openInSafari(urlString: "http://localhost:3000")
            }
            .padding()
            .background(Color.blue) // Button background color
            .cornerRadius(12) // Corner radius
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 2) // Border color and width
            )
            .foregroundColor(.white)
        }
    }
    
    // Opens a URL in Safari
    private func openInSafari(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url) { success in
                if success {
                    print("Opened \(urlString) in Safari")
                } else {
                    print("Failed to open \(urlString) in Safari")
                }
            }
        } else {
            print("Invalid URL: \(urlString)")
        }
    }
}

#Preview {
    SafariContentView(accountNumber: .constant("4567"))
}
