//
//  Modifiers.swift
//  Oily
//
//  Created by soheil pakgohar on 6/7/24.
//

import SwiftUI

struct OilCalcComfort: ViewModifier {
    
    var edges: Edge.Set = .all
    var padding: Double = 5
    func body(content: Content) -> some View {
        content
            .padding(edges, padding)
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
