//
//  ContentView.swift
//  Oily
//
//  Created by soheil pakgohar on 5/28/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 0
    @EnvironmentObject private var server: FileServer
    
    var body: some View {
        TabView(selection: $selection) {
            OilCalculatorView()
                .overlay(content: {
                    if server.existingFiles.isEmpty {
                        VStack(content: {
                            Image(systemName: "doc.fill.badge.plus")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 72))
                                .foregroundStyle(Color.gray)
                            Text("download and select a data sorce")
                            Button {
                                selection = 1
                            } label: {
                                Text("Continue")
                                    .underline()
                                    .padding(.top)
                            }
                        })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background()
                    }
                })
                .tabItem {
                    Label("calculator", systemImage: "drop.keypad.rectangle.fill")
                }
                .tag(0)
            
            FileViewer()
                .tabItem {
                    Label("data", systemImage: "folder.fill")
                }
                .tag(1)
        }
        .tint(.brown)
    }
}













#Preview {
    RootView {
        ContentView()
    }
    .environmentObject(MessageManager())
    .environmentObject(FileServer.shared)
}
