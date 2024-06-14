//
//  CalculatorButton.swift
//  Oily
//
//  Created by soheil pakgohar on 5/28/24.
//

import SwiftUI

struct CalculatorButton: View {
    
    @Environment(\.colorScheme) private var scheme
    
    var action: () -> Void
    var title: any StringProtocol
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(scheme == .dark ? .black : .white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.secondary)
        .clipShape(Capsule())
    }
}

#Preview {
    HStack{
        CalculatorButton(action: {}, title: "MR")
    }
    .padding()
    .frame(height: 40)
}
