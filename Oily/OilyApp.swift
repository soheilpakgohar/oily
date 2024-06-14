//
//  OilyApp.swift
//  Oily
//
//  Created by soheil pakgohar on 5/28/24.
//

import SwiftUI
import TipKit

@main
struct OilyApp: App {
    @StateObject private var messageManager = MessageManager()
    @StateObject private var server = FileServer.shared
    var body: some Scene {
        WindowGroup {
            RootView {
                ContentView()
            }
            .task {
                UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                if #available(iOS 17.0, *) {
                    try? Tips.configure([
                        .datastoreLocation(.applicationDefault),
                        .displayFrequency(.daily)
                    ])
                }
            }
            .environmentObject(messageManager)
            .environmentObject(server)
            
        }
    }
}
