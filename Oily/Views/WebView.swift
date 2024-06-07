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
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            WebLoader(url: url)
                .ignoresSafeArea(.all, edges: .bottom)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("done", role: .cancel) {
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
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webView.frame = .zero
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    
    
    
}

#Preview {
    WebView(url: Bundle.main.url(forResource: "help", withExtension: "html")!)
}
