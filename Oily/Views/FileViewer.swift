//
//  FileViewer.swift
//  Oily
//
//  Created by soheil pakgohar on 6/5/24.
//

import SwiftUI

struct FileViewer: View {
    
    @ObservedObject private var server = FileServer.share
    @State private var downloadURL = ""
    @State private var downloadTask = Task {}
    
    var body: some View {
        VStack {
            HStack {
                TextField("URL", text: $downloadURL)
                    .textFieldStyle(.roundedBorder)
                
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
                    Picker("", selection: $server.selectedFile) {
                        ForEach(server.existingFiles, id: \.self) { file in
                            Text(file.lastPathComponent)
                                .tag(file)
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
    }
    
    private func delete(_ indexSet: IndexSet) {
        Task {
//            for index in indexSet {
                await server.delete(at: indexSet)
//            }
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
    NavigationView {
        FileViewer()
    }
}
