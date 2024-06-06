//
//  Tank.swift
//  PlantOverview
//
//  Created by soheil pakgohar on 4/11/23.
//

import Foundation


struct Tank: Identifiable, Codable {
    
    var id: Int
    var vol: Double
    
}

extension Tank {
    
    static let mok = Tank(id: 1, vol: 0)
    
    static func + (lhs: Tank, rhs: Tank) -> Tank {
        Tank(id: 999, vol: lhs.vol + rhs.vol)
    }
}
