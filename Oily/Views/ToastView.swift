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
    
    var body: some View {
        HStack {
            Image(systemName: toast.icon)
            Text(toast.title)
                .bold()
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(Color.white, in: Capsule())
        .clipped()
        .shadow(radius: 2, y: 3)
        .shadow(color: .white, radius: 2, y: -3)
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
