//
//  Modifiers.swift
//  Oily
//
//  Created by soheil pakgohar on 6/7/24.
//

import SwiftUI

struct OilCalcComfort: ViewModifier {
    
    @Environment(\.colorScheme) private var scheme
    var edges: Edge.Set = .all
    
    func body(content: Content) -> some View {
        content
            .padding(edges)
            .background(scheme == .dark ? Color.black : Color.white, in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
    }
}

struct MakeBorderd: ViewModifier {
    
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .overlay(content: {
                RoundedRectangle(cornerRadius: 15).stroke(color)
            })
    }
}
