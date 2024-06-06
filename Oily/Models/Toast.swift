//
//  Toast.swift
//  Oily
//
//  Created by soheil pakgohar on 6/5/24.
//

import Foundation

struct Toast: Identifiable {
    var id: UUID = .init()
    var title: any StringProtocol
    var icon: String
}
