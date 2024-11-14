//
//  SafariContentView.swift
//  webViewCommucation
//
//  Created by ranjith kumar reddy b perkampally on 11/7/24.
//


import SwiftUI

struct SafariContentView: View {
    @State private var showSuccessAlert = false
    @State private var showFailureAlert = false
    @State private var receivedParams: [String: String] = [:]

    var body: some View {
        VStack {
            // Button to open Tink website in Safari
            Button("PBB in Safari") {
                openInSafari(urlString: "http://localhost:3000")
            }
            .padding()
        }
        .onOpenURL { url in
            handleURLCallback(url)
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(title: Text("Success"), message: Text("Operation completed successfully!"), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showFailureAlert) {
            Alert(title: Text("Failure"), message: Text("Operation failed."), dismissButton: .default(Text("OK")))
        }
    }

    // Function to open URL in Safari
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

    // Function to handle URL callbacks (success or failure)
    private func handleURLCallback(_ url: URL) {
        // Check if the URL matches your success or failure callback
        if url.absoluteString == "myapp://success" {
            showSuccessAlert = true
            print("Success callback received from Safari.")
        } else if url.absoluteString == "myapp://failure" {
            showFailureAlert = true
            print("Failure callback received from Safari.")
        }
    }
    
    func handleDeepLink(url: URL) {
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return
            }

            var params: [String: String] = [:]
            components.queryItems?.forEach { item in
                params[item.name] = item.value
            }

            receivedParams = params
            // You can now pass `receivedParams` to other views or perform actions
            print("Deep link received with parameters:", params)
        }
    }

#Preview {
    SafariContentView()
}

