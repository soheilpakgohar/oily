//
//  TempStepper.swift
//  Oily
//
//  Created by soheil pakgohar on 5/28/24.
//

import SwiftUI

struct TempStepper: View {
    
    let title: LocalizedStringKey
    @Binding var temp: Double
    
    var max: Double = 60.0
    var min: Double = 0.0
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.gray)
                HStack {
                    Button {
                        guard temp >= min else {return}
                        temp -= 0.1
                    } label: {
                        Image(systemName: "minus.square.fill")
                            .font(.system(size: 30))
                    }
                    .tint(.brown)
                    .disabled(temp <= min)
                    TextField("", value: $temp, format: .number)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .onSubmit {
                            if temp > max {
                                temp = max
                            }
                            if temp < min {
                                temp = min
                            }
                        }
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .frame(width: geo.size.width / 5)
                    Button {
                        guard temp < max else {return}
                        temp += 0.1
                    } label: {
                        Image(systemName: "plus.square.fill")
                            .font(.system(size: 30))
                    }
                    .tint(.brown)
                    .disabled(temp >= max)
                    Spacer(minLength: 0)
                    Text(fahrenheit)
                        .font(.system(.caption, design: .monospaced))
                        .bold()
                        .padding(.vertical, 3)
                        .padding(.horizontal, 5)
                        .foregroundColor(.white)
                        .background(Color.gray, in: Capsule())
                }
                
            }
            .modifier(OilCalcComfort())
        }
    }
    
    private var fahrenheit: String {
        let temp = Measurement(value: temp, unit: UnitTemperature.celsius)
        return temp.converted(to: UnitTemperature.fahrenheit).formatted()
    }
}

#Preview {
    TempStepper(title: "temp stepper", temp: .constant(25.0))
}
