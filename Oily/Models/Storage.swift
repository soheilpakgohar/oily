//
//  Storage.swift
//  PlantOverview
//
//  Created by soheil pakgohar on 4/16/23.
//

import Foundation


struct Storage: Codable, Identifiable, Hashable {
    
    var id: String
    var cm: [Double]
    var mm: [Double]
    
    var description: String {
        "Storage \(id)"
    }
}
