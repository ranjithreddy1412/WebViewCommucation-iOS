//
//  ContentView.swift
//  WebViewCommucation
//
//  Created by ranjith kumar reddy b perkampally on 11/18/24.
//


import SwiftUI
import WebView_iOS_SDK

struct ContentView: View, WebViewMessageHandler {
    @State private var viewType: WebViewIOSSDK.ViewType?
    private let sdk = WebViewIOSSDK()
    @State private var receivedMessage: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("PBB Navigation using SDK Example")
                    .font(.title)
                    .padding()

                Text("Message from WebView: \(receivedMessage)")
                    .foregroundColor(.blue)
                    .padding()

                NavigationLink(
                    destination: viewForType(viewType),
                    isActive: .constant(viewType != nil) // Trigger navigation when viewType is set
                ) {
                    Button("PBB Bank") {
                        handleSDKCall()
                    }
                    .padding()
                    .background(Color.blue) // Button background color
                    .cornerRadius(12) // Corner radius
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2) // Border color and width
                    )
                    .foregroundColor(.white)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }

    @ViewBuilder
    private func viewForType(_ type: WebViewIOSSDK.ViewType?) -> some View {
        if let type = type {
            switch type {
            case .web(let url):
                WebView(url: url, messageHandler: self, isDismissed: $viewType) // Display WebView in navigation
                    .navigationBarHidden(true)
            default:
                EmptyView() // Handle other types if necessary
            }
        } else {
            EmptyView() // Default case for nil
        }
    }

    
    private func handleSDKCall() {
        guard let url = URL(string: "http://localhost:3000") else { return }
        
        sdk.makeNetworkCall(url: url) { result in
            switch result {
            case .success(let url):
                sdk.navigateToWebView(using: url, openInSafari: false) { view in
                    DispatchQueue.main.async {
                        if case .safari(let url) = view {
                            openInSafari(url: url) // Navigate to Safari directly
                        } else {
                            self.viewType = view // Display WebView in a sheet
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func openInSafari(url: URL) {
        UIApplication.shared.open(url) { success in
            if success {
                print("Opened \(url) in Safari")
            } else {
                print("Failed to open \(url) in Safari")
            }
        }
    }

    // MARK: - WebViewMessageHandler Implementation
    func onMessageReceived(_ message: String) {
        DispatchQueue.main.async {
            receivedMessage = message
            print("Message received from WebView: \(message)")
        }
    }
}

// Extend the ViewType to conform to Identifiable
extension WebViewIOSSDK.ViewType: @retroactive Identifiable {
    public var id: URL {
        switch self {
        case .safari(let url), .web(let url):
            return url
        }
    }
}
