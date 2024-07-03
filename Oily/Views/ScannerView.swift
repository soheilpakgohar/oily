//
//  ScannerView.swift
//  Chargy
//
//  Created by Soheil Pakgohar on 6/14/20.
//  Copyright © 2020 Soheil Pakgohar. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

struct ScannerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ScannerViewController
    @Binding var lin: Double
    @Binding var temp: Double
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let controller = ScannerViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ScannerViewControllerDelegate {
        
        let parent: ScannerView
        var effect: AVAudioPlayer?
        
        init(_ parent: ScannerView) {
            self.parent = parent
        }
        
        func found(code: String) {
            let parts = code.split(separator: ";")
            parent.lin = Double(parts[11].description)!
            parent.temp = Double(parts[10].description)!
            playSound()
            parent.dismiss()
        }
        
        private func playSound() {
            let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/sms-received1.caf")
            do {
                effect = try AVAudioPlayer(contentsOf: url)
                effect?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
