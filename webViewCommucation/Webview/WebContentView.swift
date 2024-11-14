//
//  WebContentView.swift
//  webViewCommucation
//
//  Created by ranjith kumar reddy b perkampally on 11/12/24.
//

import SwiftUI

//struct WebContentView: View {
//    
//    @State private var showWebView = false
//    
//    var body: some View {
//        VStack {
//            Button("PBB in WebView") {
//                showWebView = true
//            }
//            .sheet(isPresented: $showWebView) {
//                if let url = URL(string: "http://localhost:3000") {
//                    WebView(url: url)
//                }
//            }
//        }
//    }
//}

struct WebContentView: View {
    @State private var showWebView = false
    @State private var successMessage: String? = nil

    var body: some View {
        VStack {
            
            if let message = successMessage {
                Text("Message from WebView: \(message)")
                    .padding()
            }
            Button("PBB in WebView") {
                showWebView = true
            }
            .sheet(isPresented: $showWebView) {
                if let url = URL(string: "http://localhost:3000") {
                    WebView(url: url, onClose: { data in
                        successMessage = data // Receive data when WebView is closed
                    })
                }
            }
        }
    }
}

#Preview {
    WebContentView()
}


