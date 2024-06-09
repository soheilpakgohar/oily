//
//  FileViewer.swift
//  Oily
//
//  Created by soheil pakgohar on 6/5/24.
//

import SwiftUI

struct FileViewer: View {
    
    @EnvironmentObject private var server: FileServer
    @State private var downloadURL = ""
    @State private var downloadTask = Task {}
    @State private var confirmation = false
    @State private var confirmationItem: Int?
    @State private var helpSheet = false
    @AppStorage("selectedFile") private var selectedFile: URL?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 15) {
                    TextField("URL", text: $downloadURL)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        }
                    
                    Group {
                        if server.isBusy {
                            ProgressView()
                                .onTapGesture {
                                    downloadTask.cancel()
                                }
                        } else {
                            Button {
                                downloadTask = Task {
                                    await server.download(from: downloadURL)
                                }
                            } label: {
                                Image(systemName: "arrow.down")
                            }
                            .tint(.oilish)
                            .buttonStyle(.borderedProminent)
                            .clipShape(Circle())
                            
                        }
                    }
                    .frame(width: 25, height: 25, alignment: .center)
                    .animation(.default, value: server.isBusy)
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                           helpSheet = true
                        } label: {
                            Label("Help", systemImage: "questionmark.circle")
                                .tint(.oilish)
                        }
                    }
                }
                .sheet(isPresented: $helpSheet) {
                    WebView(url: Bundle.main.url(forResource: "help", withExtension: "html")!)
                }
                
                Group {
                    if server.existingFiles.isEmpty {
                        if #available(iOS 17.0, *) {
                            ContentUnavailableView("Empty Repository", systemImage: "doc.text.magnifyingglass")
                        } else {
                            VStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .font(.system(size: 72))
                                    .foregroundStyle(Color.gray)
                                Text("Empty Repository")
                                    .font(.title)
                                    .bold()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    } else {
                        List {
                            Section {
                                ForEach(Array(server.existingFiles.enumerated()), id: \.offset) { index, file in
                                    HStack {
                                        Image(systemName: "doc.text")
                                        Text(file.lastPathComponent)
                                        Spacer(minLength: 0)
                                        if file.lastPathComponent == selectedFile?.lastPathComponent {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(Color.oilish)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedFile = file
                                    }
                                    .swipeActions {
                                        Button {
                                            confirmDeletation(index)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                                .labelStyle(.iconOnly)
                                        }
                                    }
                                }
                            } header: {
                                Text("Files")
                                    .textCase(.none)
                            }
                            
                            /*Section {
                                
                            } header: {
                                Text("Settings")
                            }*/
                        }
                        .listStyle(.plain)
                        .confirmationDialog("Sure to Delete?", isPresented: $confirmation, presenting: confirmationItem) { index in
                            Button("Delete", role: .destructive) {delete(index)}
                            Button("Cancel", role: .cancel) {}
                        }
                    }
                }
                .navigationTitle("File Maneger")
                .navigationBarTitleDisplayMode(.inline)
                
                Spacer(minLength: 0)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    private func confirmDeletation(_ index: Int) {
        confirmation = true
        confirmationItem = index
    }
    
    private func delete(_ index: Int) {
        Task {
            await server.delete(at: index)
        }
    }
}

#Preview {
    FileServer.shared.existingFiles = [URL(string: "file:///Users/soheilpakgohar/Library/Developer/CoreSimulator/Devices/478F4C56-E0D7-43FA-9525-05E0E25671F6/data/Containers/Data/Application/567E4534-F698-4BAF-9419-AE17C7A2D876/Documents/B91AB2186470-isin.json")!]
    return FileViewer()
            .environmentObject(FileServer.shared)
}
