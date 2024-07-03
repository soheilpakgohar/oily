//
//  ConverterView.swift
//  Oily
//
//  Created by soheil pakgohar on 7/1/24.
//

import SwiftUI
import Combine

struct ConverterView: View {
    
    var body: some View {
        TabView {
            UsageConverterView()
                .tag(0)
            
            LoadConverterView()
                .tag(1)
        }
        .tabViewStyle(.page)
        .ignoresSafeArea(.all, edges: .top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct UsageConverterView: View {
    
    @EnvironmentObject private var focalculator: FuelOilCalculator
    @FocusState private var keyboard
    var body: some View {
        VStack {
            HStack {
                Text("Usage Converter")
                    .font(.title3)
                    .bold()
                
                Spacer(minLength: 0)
                
                Button {
                    focalculator.deep = 0.0
                } label: {
                    Image(systemName: "arrow.2.squarepath")
                        .imageScale(.medium)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            Form {
                Section {
                    Text(focalculator.liter, format: .number)
                        .font(.system(size: 48, design: .monospaced))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .textSelection(.enabled)
                } footer: {
                    Text("The number produced in this procedure cannot be cited even in short intervals like one day. Note that the above number can only be used to have a correct understanding of the difference with the normal value")
                }
                
                Section {
                    TextField("Liter", value: $focalculator.deep, format: .number)
                        .font(.system(size: 24, design: .monospaced))
                        .foregroundStyle(Color.accentColor)
                        .keyboardType(.decimalPad)
                        .focused($keyboard)
                } header: {
                    Text("Liter in actual temprature")
                        .textCase(.none)
                }
                
                Section {
                    Stepper(value: $focalculator.tankTemp, step: 0.1) {
                        Text(focalculator.tankTemp, format: .number)
                            .font(.system(size: 24, design: .monospaced))
                    }
                    .foregroundStyle(Color.accentColor)
                } header: {
                    Text("Temprature")
                        .textCase(.none)
                } footer: {
                    HStack {
                        Text(focalculator.fahrenheit(of: focalculator.tankTemp), format: .number)
                        Text("in Fahrenheit")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button("Done") {
                            keyboard = false
                        }
                        Spacer(minLength: 0)
                    }
                }
            }
            .onAppear {
                focalculator.convertorMode = true
            }
            .onDisappear {
                focalculator.convertorMode = false
            }
        }
        .background()
    }
}

struct LoadConverterView: View {
    
    @FocusState private var keyboard
    @State private var defaultLoad = 29000.0
    @State private var docTemp = 0.0
    @State private var actualTemp = 0.0
    @State private var scanMode = false
    var body: some View {
        VStack {
            HStack {
                Text("Load Converter")
                    .font(.title3)
                    .bold()
                
                Spacer(minLength: 0)
                
                Button {
                    scanMode.toggle()
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .imageScale(.medium)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
                
                Button {
                    defaultLoad = 29000.0
                    actualTemp = 0.0
                } label: {
                    Image(systemName: "arrow.2.squarepath")
                        .imageScale(.medium)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            Form {
                Section {
                    TextField("Load", value: $defaultLoad, format: .number)
                        .font(.system(size: 48, design: .monospaced))
                        .keyboardType(.numberPad)
                        .focused($keyboard)
                } footer: {
                    Text("Load provided by document")
                        .textCase(.none)
                }
                
                Section {
                    TextField("Tempreture", value: $docTemp, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($keyboard)
                } header: {
                    Text("Tempreture in Load's Paper (F)")
                        .textCase(.none)
                } footer: {
                    HStack {
                        Text(celsius(of: docTemp), format: .number)
                        Text("C")
                    }
                }
                
                Section {
                    TextField("Current Tempreture", value: $actualTemp, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($keyboard)
                    
                } header: {
                    Text("Current Temp of Load (C)")
                        .textCase(.none)
                } footer: {
                    HStack {
                        Text(fahrenheit(of: actualTemp), format: .number)
                        Text("F")
                    }
                }
                
                Section {
                    Button {
                        makeChange(for: actualTemp)
                    } label: {
                        Label("Calculate", systemImage: "arrow.forward.circle.fill")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
            .sheet(isPresented: $scanMode, content: {
                ScannerView(lin: $defaultLoad, temp: $docTemp)
                    .ignoresSafeArea()
            })
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button("Done") {
                            keyboard = false
                        }
                        Spacer(minLength: 0)
                    }
                }
            }
        }
        .background()
    }
    
    private func celsius(of temp: Double) -> Double {
        Measurement(value: temp, unit: UnitTemperature.fahrenheit).converted(to: UnitTemperature.celsius).value
    }
    
    private func fahrenheit(of temp: Double) -> Double {
        Measurement(value: temp, unit: UnitTemperature.celsius).converted(to: UnitTemperature.fahrenheit).value
    }
    
    private func makeChange(for temp: Double) {
        let deltaT = fahrenheit(of: temp) - docTemp
        defaultLoad += (deltaT * 14.5)
    }
}

#Preview {
    ConverterView()
        .environmentObject(FuelOilCalculator())
}
