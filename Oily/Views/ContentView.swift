//
//  ContentView.swift
//  Oily
//
//  Created by soheil pakgohar on 5/28/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 0
    @AppStorage("selectedFile") private var selectedFile: URL?
    
    var body: some View {
        TabView(selection: $selection) {
            OilCalculatorView()
                .overlay(content: {
                    if selectedFile == nil {
                        if #available(iOS 17.0, *) {
                            ContentUnavailableView(label: {
                                Label("No Data", systemImage: "doc.fill.badge.plus")
                            }, description: {
                                Text("download and select a data source")
                            }, actions: {
                                Button(action: {
                                    selection = 1
                                }) {
                                    Text("Continue")
                                        .underline()
                                }
                            })
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background()
                        } else {
                            VStack(content: {
                                Image(systemName: "doc.fill.badge.plus")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 72))
                                    .foregroundStyle(Color.gray)
                                Text("download and select a data source")
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
                    }
                })
                .tabItem {
                    Label("Calculator", systemImage: "drop.keypad.rectangle.fill")
                }
                .tag(0)
            
            FileViewer()
                .tabItem {
                    Label("Files", systemImage: "folder.fill")
                }
                .tag(1)
        }
    }
}

#Preview {
    RootView {
        ContentView()
    }
    .environmentObject(MessageManager())
    .environmentObject(FileServer.shared)
}
