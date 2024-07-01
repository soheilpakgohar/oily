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
    
    private var fahrenheit: String {
        let temp = Measurement(value: temp, unit: UnitTemperature.celsius)
        return temp.converted(to: UnitTemperature.fahrenheit).value.formatted()
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Spacer(minLength: 0)
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.gray)
                HStack {
                    Button {
                        guard temp >= min else {return}
                        temp -= 0.1
                    } label: {
                        Image(systemName: "minus.square")
                            .font(.system(size: 30))
                    }
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
                        .frame(width: geo.size.width / 4)
                    Button {
                        guard temp < max else {return}
                        temp += 0.1
                    } label: {
                        Image(systemName: "plus.square")
                            .font(.system(size: 30))
                    }
                    .disabled(temp >= max)
                    Spacer(minLength: 0)
                    Text(fahrenheit + "℉")
                        .font(.system(.caption, design: .monospaced))
                        .bold()
                        .padding(.vertical, 3)
                        .padding(.horizontal, 5)
                        .foregroundColor(.white)
                        .background(Color.gray, in: RoundedRectangle(cornerRadius: 5))
                }
                Spacer(minLength: 0)
            }
            .modifier(OilCalcComfort(padding: 10))
        }
        .frame(height: 100)
    }
}

#Preview {
    TempStepper(title: "Temp Stepper", temp: .constant(25.0))
}
