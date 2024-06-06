//
//  FuelOil.swift
//  PlantOverview
//
//  Created by soheil pakgohar on 4/16/23.
//

import Foundation


struct FuelOil: Codable {
    
    var storages: [Storage]
    var cts: [Double]
    var underground: Double
    var pipline: Double
}
