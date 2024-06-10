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
    
    private init() {
        explore()
    }
    
    static let shared = FileServer()
    
    func explore() {
        do {
            let docsDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            existingFiles = try FileManager.default.contentsOfDirectory(at: docsDir, includingPropertiesForKeys: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func download(from urlString: String) async {
        isBusy = true
        let uuid = UUID().lastPartComponent
        defer {
            isBusy = false
        }
        guard let url = URL(string: urlString), url.pathExtension == "json" else {return}
        do {
            let saveUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let (tempUrl, response) = try await URLSession.shared.download(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
            try FileManager.default.moveItem(at: tempUrl, to: saveUrl.appendingPathComponent("\(uuid)-\(url.lastPathComponent)"))
            explore()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(at index: Int) async {
        if let selected = userDefaults.url(forKey: "selectedFile") , selected.lastPathComponent == existingFiles[index].lastPathComponent {
            userDefaults.removeObject(forKey: "selectedFile")
        }
        do {
            try FileManager.default.removeItem(at: existingFiles[index])
            explore()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension UUID {
    public var lastPartComponent: String {
        self.uuidString.split(separator: "-").last!.description
    }
}
