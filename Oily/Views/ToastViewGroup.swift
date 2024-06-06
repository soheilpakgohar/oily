//
//  ToastViewGroup.swift
//  Oily
//
//  Created by soheil pakgohar on 6/5/24.
//

import SwiftUI

struct ToastViewGroup: View {
    @EnvironmentObject private var messageManager: MessageManager
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(messageManager.toasts) { toast in
                    ToastView(toast: toast)
                }
            }
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}

#Preview {
    ToastViewGroup()
        .environmentObject(MessageManager())
}
