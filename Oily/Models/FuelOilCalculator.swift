//
//  FuelOilCalculator.swift
//  PlantOverview
//
//  Created by soheil pakgohar on 4/16/23.
//

import Foundation
import UIKit
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
    @Published var ambiantLockToTank = true {
        didSet {
            userDefaults.setValue(ambiantLockToTank, forKey: "ambiantLockToTank")
        }
    }
    
    @Published var convertorMode: Bool = false {
        didSet {
            deep = 0.0
            liter = 0.0
        }
    }
    
    private var cancelableSet = Set<AnyCancellable>()
    
    init() {
        temp = userDefaults.double(forKey: "temp")
        tankTemp = userDefaults.double(forKey: "tankTemp")
        ambiantLockToTank = userDefaults.bool(forKey: "ambiantLockToTank")
        converter.receive(on: RunLoop.main).sink(receiveValue: {_ in}).store(in: &cancelableSet)
        guard let selectedFile = userDefaults.url(forKey: "selectedFile") else {return}
        Task {
            await getData(from: selectedFile)
        }
    }
    
    @MainActor
    func getData(from source: URL) async {
        guard FileManager.default.fileExists(atPath: source.relativePath) else {return}

        do {
            let dataFile = try Data(contentsOf: source)
            let data = try JSONDecoder().decode(FuelOil.self, from: dataFile)
            storages = data.storages
            cts = data.cts
            pipline = data.pipline
            underground = data.underground
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deepIsVerified() -> Bool {
        deep > 0.0 && deep < Double(storages[selectedStorage - 1].cm.count) * 0.01
    }
    
    func splitDeep() -> (Int, Int) {
        guard deepIsVerified() else {return (0,0)}
        let meter = Measurement(value: deep, unit: UnitLength.meters)
        let centimeter = meter.converted(to: .centimeters).value
        let millimeter = meter.converted(to: .millimeters).value
        return (Int(centimeter), Int(centimeter * 10 - millimeter))
    }
    
    func fahrenheit(of temp: Double) -> Double {
        let celcius = Measurement(value: temp, unit: UnitTemperature.celsius)
        return celcius.converted(to: .fahrenheit).value
    }
    
    var sixtyFactor: Double {
        1 - (fahrenheit(of: tankTemp) - 60) * 0.00048
    }
    
    func getCts() -> Double {
        let t = (7 * fahrenheit(of: tankTemp) + fahrenheit(of: ambiantLockToTank ? tankTemp : temp)) / 8
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
        guard !convertorMode else {
            liter = (deep * sixtyFactor).rounded()
            return
        }
        let (cm, mm) = splitDeep()
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
    
    private var converter: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($deep, $tankTemp)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {_, _ in
                if self.convertorMode {
                    self.calculate()
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
}
