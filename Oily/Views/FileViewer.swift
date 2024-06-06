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
    @AppStorage("selectedFile") private var selectedFile = URL(string:"www.apple.com")!
    
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
                
                Group {
                    if server.existingFiles.isEmpty {
                        if #available(iOS 17.0, *) {
                            ContentUnavailableView("Not Found", systemImage: "doc.text.magnifyingglass")
                        } else {
                            VStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                Text("Not Found")
                            }
                        }
                    } else {
                        List {
                            ForEach(server.existingFiles, id: \.self) { file in
                                HStack {
                                    Image(systemName: "doc.text")
                                    Text(file.lastPathComponent)
                                    Spacer(minLength: 0)
                                    if file.lastPathComponent == selectedFile.lastPathComponent {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Color.brown)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedFile = file
                                }
                            }
                            .onDelete(perform: delete)
                        }
                        .listStyle(.plain)
                    }
                }
                
                Spacer(minLength: 0)
            }
        }
    }
    
    private func delete(_ indexSet: IndexSet) {
        Task {
            await server.delete(at: indexSet)
        }
    }
    
    @ViewBuilder
    private func downloadLabel() -> some View {
        ZStack {
            Circle()
                .stroke()
                .foregroundStyle(Color.secondary)
                .frame(width: 25, height: 25)
            Circle()
                .trim(from: 0.0, to: 0.0)
                .stroke(lineWidth: 2)
                .frame(width: 25, height: 25)
                .rotationEffect(Angle(degrees: -90))
            
            
            Image(systemName: "arrow.down")
            
        }
    }
}

#Preview {
    FileViewer()
        .environmentObject(FileServer.shared)
}
