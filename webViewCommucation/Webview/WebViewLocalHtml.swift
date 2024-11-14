//
//  WebView.swift
//  webViewCommucation
//
//  Created by ranjith kumar reddy b perkampally on 11/7/24.
//

import SwiftUI
import WebKit

struct WebViewLocalHtml: UIViewRepresentable {
    var onSuccess: () -> Void
    var onFailure: () -> Void

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "callbackHandler")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        
        // Load the HTML file from the app bundle
        if let filePath = Bundle.main.path(forResource: "Callback", ofType: "html") {
            let fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
            webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
            print("WebView: Loaded HTML file from \(fileURL.absoluteString)")
        } else {
            print("WebView: Failed to load HTML file.")
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKScriptMessageHandler {
        var parent: WebViewLocalHtml

        init(_ parent: WebViewLocalHtml) {
            self.parent = parent
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "callbackHandler", let messageBody = message.body as? String else { return }
            
            print("WebView: Received message from JavaScript - \(messageBody)")
            
            if messageBody == "success" {
                print("WebView: Success callback triggered")
                parent.onSuccess()
            } else if messageBody == "failure" {
                print("WebView: Failure callback triggered")
                parent.onFailure()
            }
        }
    }
}

