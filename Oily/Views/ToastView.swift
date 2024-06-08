//
//  ToastView.swift
//  Oily
//
//  Created by soheil pakgohar on 6/5/24.
//

import SwiftUI

struct ToastView: View {
    var toast: Toast
    @State private var animateIn = false
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        HStack {
            Image(systemName: toast.icon)
                .foregroundStyle(Color.brown)
            Text(toast.title)
                .bold()
                
        }
        
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(scheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.1), in: Capsule())
        .clipped()
        .offset(y: animateIn ? 0 : 150)
        .task {
            guard !animateIn else {return}
            withAnimation(.snappy) {
                animateIn = true
            }
        }
    }
}

#Preview {
    ToastView(toast: Toast.init(title: "coppied", icon: "doc.on.doc"))
}
