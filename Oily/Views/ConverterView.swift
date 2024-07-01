//
//  ConverterView.swift
//  Oily
//
//  Created by soheil pakgohar on 7/1/24.
//

import SwiftUI

struct ConverterView: View {
    
    @EnvironmentObject private var focalculator: FuelOilCalculator
    @FocusState private var keyboard
    var body: some View {
        NavigationView {
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
            .navigationTitle(Text("Converter"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button("Done") {
                            keyboard = false
                        }
                        Spacer(minLength: 0)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        focalculator.deep = 0.0
                    } label: {
                        Image(systemName: "arrow.2.squarepath")
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
    }
}

#Preview {
    ConverterView()
        .environmentObject(FuelOilCalculator())
}
