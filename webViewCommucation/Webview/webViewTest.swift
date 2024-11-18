//
//  webView.swift
//  webViewCommucation
//
//  Created by ranjith kumar reddy b perkampally on 11/12/24.
//
import SwiftUI
import WebKit

struct WebViewTest: UIViewRepresentable {
    let url: URL
    var onClose: (String) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> UIView {
        // Set up a container view to hold both WKWebView and close button
        let containerView = UIView()

        // Create and configure WKWebView
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        containerView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: containerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        // Load the URL
        webView.load(URLRequest(url: url))

        // Create Close Button
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(context.coordinator, action: #selector(context.coordinator.closeWebView), for: .touchUpInside)

        // Configure button layout
        containerView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewTest

        init(_ parent: WebViewTest) {
            self.parent = parent
        }

        @objc func closeWebView() {
            parent.onClose("Successfully: Added account")
            
            // Dismiss view controller by accessing the window scene in a safe way
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
}

