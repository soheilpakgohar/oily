//
//  OilyApp.swift
//  Oily
//
//  Created by soheil pakgohar on 5/28/24.
//

import SwiftUI

@main
struct OilyApp: App {
    @StateObject private var messageManager = MessageManager()
    @StateObject private var server = FileServer.shared
    var body: some Scene {
        WindowGroup {
            RootView {
                ContentView()
            }
            .environmentObject(messageManager)
            .environmentObject(server)
        }
    }
}
