//
//  MessageManager.swift
//  Oily
//
//  Created by soheil pakgohar on 6/5/24.
//

import Foundation


class MessageManager: ObservableObject {
    @Published var toasts: [Toast] = []
    
    func showMessage( _ toast: Toast) {
        toasts.append(toast)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            removeMessage(toast: toast)
        }
    }
    
    func removeMessage(toast: Toast) {
        toasts.removeAll(where: {$0.id == toast.id})
    }
}
