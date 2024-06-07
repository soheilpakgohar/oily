//
//  Extension+View.swift
//  Oily
//
//  Created by soheil pakgohar on 6/7/24.
//

import SwiftUI

extension View {
    func bordered(color: Color = .oilish) -> some View {
        self.modifier(MakeBorderd(color: color))
    }
}


