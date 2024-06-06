//
//  FuelOilCalculator.swift
//  PlantOverview
//
//  Created by soheil pakgohar on 4/16/23.
//

import Foundation
import Combine


class FuelOilCalculator: ObservableObject {
    
    let userDefaults = UserDefaults.standard
    
    @Published var storages = [Storage]()
    var cts = [Double]()
    
    var pipline: Double = 0
    var underground: Double = 0
    
    @Published var liter: Double = 0
    @Published var deep: Double = 0
    @Published var tankTemp: Double {
        didSet {
            userDefaults.setValue(tankTemp, forKey: "tankTemp")
        }
    }
    @Published var temp: Double {
        didSet {
            userDefaults.setValue(temp, forKey: "temp")
        }
    }
    @Published var sixty = true
    @Published var selectedStorage: Int = 1
    @Published var memory = [Double]()
    
    init() {
        temp = userDefaults.double(forKey: "temp")
        tankTemp = userDefaults.double(forKey: "tankTemp")
        Task {
            await getData()
        }
    }
    
    @MainActor
    func getData() async {
        let data = Bundle.main.decode(FuelOil.self, from: "isin.json")
        storages = data.storages
        cts = data.cts
        pipline = data.pipline
        underground = data.underground
    }
    
    func splitDeep() -> (Int, Int) {
        let meter = Measurement(value: deep, unit: UnitLength.meters)
        let centimeter = meter.converted(to: .centimeters)
        let deepComponent = centimeter.value.description.split(separator: ".")
        
        return (Int(deepComponent[0]) ?? 0,Int(deepComponent[1]) ?? 0)
    }
    
    func fahrenheit(of temp: Double) -> Double {
        let celcius = Measurement(value: temp, unit: UnitTemperature.celsius)
        return celcius.converted(to: .fahrenheit).value
    }
    
    var sixtyFactor: Double {
        1 - (fahrenheit(of: tankTemp) - 60) * 0.00048
    }
    
    func getCts() -> Double {
        let t = (7 * fahrenheit(of: tankTemp) + fahrenheit(of: temp)) / 8
        return cts[Int(t) - 32]
    }
    
    func clearAll() {
        liter = 0
        memory.removeAll()
    }
    
    func popMemory() {
        if memory.isEmpty == false {
            memory.remove(at: memory.count - 1)
        }
    }
    
    func calculate() {
        let (cm, mm) = splitDeep()
        guard cm < storages[selectedStorage - 1].cm.count , mm < storages[selectedStorage - 1].mm.count else {
            liter = 0
            return
        }
        let volume = storages[selectedStorage - 1].cm[cm] + storages[selectedStorage - 1].mm[mm]
        let normalVolume = volume * getCts()
        if sixty {
            let sixtyVolume = normalVolume * sixtyFactor
            memory.append(sixtyVolume.rounded())
            liter = sixtyVolume.rounded()
        } else {
            memory.append(normalVolume.rounded())
            liter = normalVolume.rounded()
        }
    }
    
    func total() {
        liter = memory.reduce(pipline + underground, +).rounded()
        memory.removeAll()
    }
    
}
