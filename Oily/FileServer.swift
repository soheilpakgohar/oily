//
//  FileServer.swift
//  KKS
//
//  Created by soheil pakgohar on 5/14/24.
//

import Foundation

@MainActor
class FileServer: ObservableObject {
   
    let userDefaults = UserDefaults.standard
    
    @Published var isBusy = false
    @Published var existingFiles: [URL] = []
    @Published var selectedFile: URL = URL(string: "www.apple.com")!
    
    private init() {
        explore()
        
        guard let selected = userDefaults.url(forKey: "selectedfile") else {return}
        selectedFile = selected
    }
    
    static let share = FileServer()
    
    func explore() {
        existingFiles = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    }
    
    func download(from urlString: String) async {
        isBusy = true
        let uuid = UUID().lastPartComponent
        defer {
            isBusy = false
        }
        guard let url = URL(string: urlString) else {return}
        do {
            let saveUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let (tempUrl, response) = try await URLSession.shared.download(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
            try FileManager.default.moveItem(at: tempUrl, to: saveUrl.appendingPathComponent("\(uuid)-\(url.lastPathComponent)"))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(at indexSet: IndexSet) async {
        for index in indexSet {
            do {
                try FileManager.default.removeItem(at: existingFiles[index])
                explore()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension UUID {
    public var lastPartComponent: String {
        self.uuidString.split(separator: "-").last!.description
    }
}
