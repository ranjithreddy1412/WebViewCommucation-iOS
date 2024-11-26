//
//  webViewCommucationApp.swift
//  webViewCommucation
//
//  Created by ranjith kumar reddy b perkampally on 11/7/24.
//

import SwiftUI

@main
struct webViewCommucationApp: App {
    
    @State private var accountNumber: String?
    var body: some Scene {
        WindowGroup {
            //            WebContentViewLocalHtml()
            SafariContentView(accountNumber: $accountNumber)
//                        WebContentView()
//                        ContentView()
                .onOpenURL { url in
                    handleRedirectURL(url)
                }
        }
    }
    
    private func handleRedirectURL(_ url: URL) {
        print("Received callback from Tink: \(url.absoluteString)")

        // Debugging: Log URL components
        print("URL Scheme: \(url.scheme ?? "nil")")
        print("URL Host: \(url.host ?? "nil")")
        print("URL Path: \(url.path)")
        print("URL Query: \(url.query ?? "nil")")

        // Validate scheme and host
        guard url.scheme?.lowercased() == "sampletinkapp", url.host?.lowercased() == "callback" else {
            print("Invalid URL - Scheme: \(url.scheme ?? ""), Host: \(url.host ?? "")")
            return
        }

        // Parse query parameters
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            // Log all query items for debugging
            for queryItem in queryItems {
                print("Query Item: \(queryItem.name) = \(queryItem.value ?? "nil")")
            }

            // Extract the account number
            if let accountNumberParam = queryItems.first(where: { $0.name == "accountNumber" })?.value {
                print("Received account number: \(accountNumberParam)")
                accountNumber = accountNumberParam // Update state
            } else {
                print("No account number found in the URL.")
            }
        } else {
            print("Failed to parse query parameters.")
        }
    }

}
