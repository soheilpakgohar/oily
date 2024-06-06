//
//  RootView.swift
//  Oily
//
//  Created by soheil pakgohar on 6/5/24.
//

import SwiftUI

struct RootView<Content: View>: View {
    
    @ViewBuilder var content: Content
    @State private var overlayWindow: UIWindow?
    @EnvironmentObject private var messageManager: MessageManager
    var body: some View {
        content
            .onAppear {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
                    let window = PassThroughWindow(windowScene: windowScene)
                    window.backgroundColor = .clear
                    let rootController = UIHostingController(rootView: ToastViewGroup().environmentObject(messageManager))
                    rootController.view.frame = windowScene.keyWindow?.frame ?? .zero
                    rootController.view.backgroundColor = .clear
                    window.rootViewController = rootController
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    window.tag = 1009
                    
                    overlayWindow = window
                }
            }
    }
}

#Preview {
    RootView {
        ContentView()
    }
    .environmentObject(MessageManager())
}
