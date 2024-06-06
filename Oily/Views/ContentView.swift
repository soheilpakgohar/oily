//
//  ContentView.swift
//  Oily
//
//  Created by soheil pakgohar on 5/28/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            OilCalculatorView()
                .tabItem {
                    Label("calculator", systemImage: "drop.keypad.rectangle.fill")
                }
            FileViewer()
                .tabItem {
                    Label("data", systemImage: "folder.fill")
                }
        }
        .tint(.brown)
    }
}













#Preview {
    RootView {
        ContentView()
    }
    .environmentObject(MessageManager())
}
