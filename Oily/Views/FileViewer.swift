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
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1.5)
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
                            .tint(.brown)
                            .buttonStyle(.borderedProminent)
                            .clipShape(Circle())
                            
                        }
                    }
                    .frame(width: 25, height: 25, alignment: .center)
                    .animation(.default, value: server.isBusy)
                }
                .padding()
                .navigationTitle("File Maneger")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                           helpSheet = true
                        } label: {
                            Label("help", systemImage: "questionmark.circle")
                                .tint(.brown)
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
                            ForEach(Array(server.existingFiles.enumerated()), id: \.offset) { index, file in
                                HStack {
                                    Image(systemName: "doc.text")
                                    Text(file.lastPathComponent)
                                    Spacer(minLength: 0)
                                    if file.lastPathComponent == selectedFile?.lastPathComponent {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Color.brown)
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
                                        Label("delete", systemImage: "trash")
                                            .labelStyle(.iconOnly)
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .confirmationDialog("sure to delete?", isPresented: $confirmation, presenting: confirmationItem) { index in
                            Button("delete", role: .destructive) {delete(index)}
                            Button("cancel", role: .cancel) {}
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Image("oil-horizon")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 80)
                    .blur(radius: 3)
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
    FileViewer()
        .environmentObject(FileServer.shared)
}
