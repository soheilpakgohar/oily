//
//  WebView.swift
//  Oily
//
//  Created by soheil pakgohar on 6/6/24.
//

import SwiftUI
import WebKit

struct WebView: View {
    var url: URL
    @State private var isLoading = true
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                WebLoader(url: url, isLoading: $isLoading)
                if isLoading {
                    ProgressView("Loading...")
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct WebLoader: UIViewRepresentable {
    typealias UIViewType = WKWebView
    var url: URL
    @Binding var isLoading: Bool
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let urlRequest = URLRequest(url: url)
        webView.navigationDelegate = context.coordinator
        webView.load(urlRequest)
        webView.frame = .zero
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebLoader
        
        init(_ parent: WebLoader) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
}

#Preview {
    WebView(url: Bundle.main.url(forResource: "help", withExtension: "html")!)
}
