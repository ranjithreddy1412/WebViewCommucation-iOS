//
//  ContentView.swift
//  webViewCommucation
//
//  Created by ranjith kumar reddy b perkampally on 11/7/24.
//


import SwiftUI

struct WebContentViewLocalHtml: View {
    @State private var navigateToWebView = false
    @State private var showSuccessAlert = false
    @State private var showFailureAlert = false

    var body: some View {
        NavigationStack {
            VStack {
                // Button to navigate to WebView
                Button("Go to WebView") {
                    navigateToWebView = true
                }
                .padding()
                .navigationTitle("Home")
                .navigationDestination(isPresented: $navigateToWebView) {
                    WebViewLocalHtml(
                        onSuccess: {
                            showSuccessAlert = true
                            print("ContentView: Success callback received from WebView.")
                        },
                        onFailure: {
                            showFailureAlert = true
                            print("ContentView: Failure callback received from WebView.")
                        }
                    )
                    .alert(isPresented: $showSuccessAlert) {
                        Alert(title: Text("Success"), message: Text("Success callback triggered"), dismissButton: .default(Text("OK")))
                    }
                    .alert(isPresented: $showFailureAlert) {
                        Alert(title: Text("Failure"), message: Text("Failure callback triggered"), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
}

#Preview {
    WebContentViewLocalHtml()
}
