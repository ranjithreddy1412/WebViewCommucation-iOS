//
//  webViewCommucationApp.swift
//  webViewCommucation
//
//  Created by ranjith kumar reddy b perkampally on 11/7/24.
//

import SwiftUI

@main
struct webViewCommucationApp: App {
    var body: some Scene {
        WindowGroup {
            
//             WebContentViewLocalHtml()
//            SafariContentView()
            
             //WebContentView()
            ContentView()
                .onOpenURL { url in
                    handleIncomingURL(url)
                }
        }
    }
    private func handleTinkCallback(_ url: URL) {
        if url.scheme == "sampleTinkapp" && url.host == "callback" {
            // Handle the callback data here
            print("Received callback from Tink: \(url.absoluteString)")
            // Parse any query parameters if necessary
            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
                for queryItem in queryItems {
                    print("Query item: \(queryItem.name) = \(queryItem.value ?? "")")
                }
            }
        }
    }
    
    private func handleIncomingURL(_ url: URL) {
        print("Received callback from Tink: \(url.absoluteString)")
            guard url.scheme == "sampleTinkapp" && url.host == "callback"
        else {
                return
            }
       
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                print("Invalid URL")
                return
            }

            guard let action = components.host, action == "open-recipe" else {
                print("Unknown URL, we can't handle this one!")
                return
            }

        }
}
