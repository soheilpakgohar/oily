//
//  OilCalculatorView.swift
//  PlantOverview
//
//  Created by soheil pakgohar on 4/12/23.
//

import SwiftUI

struct OilCalculatorView: View {
    
    @EnvironmentObject private var messageManager: MessageManager
    @StateObject private var focalculator = FuelOilCalculator()
    @FocusState private var keyboard
    @Environment(\.displayScale) var ds
    @Environment(\.colorScheme) var scheme
    @AppStorage("selectedFile") private var selectedFile = URL(string: "www.apple.com")!
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    Text(focalculator.memory.map {String(describing: $0)}.joined(separator: ","))
                        .font(.caption)
                        .bold()
                        .padding([.top, .leading])
                    
                    TextField("liter", value: $focalculator.liter, format: .number)
                        .font(.system(size: 68, design: .monospaced))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .disabled(true)
                        .padding([.vertical , .leading])
                        .contentShape(Rectangle())
                        .onTapGesture(count: 2, perform: {
                            guard focalculator.liter != 0.0 else {return}
                            UIPasteboard.general.string = String(describing: focalculator.liter)
                            messageManager.showMessage(Toast(title: "coppied", icon: "doc.on.doc"))
                        })
                    
                }
                .bordered()
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .layoutPriority(1)
                
                
                ScrollView {
                    VStack(spacing: 15) {
                        
                        HStack {
                            Image(systemName: "ruler")
                                .imageScale(.large)
                                .foregroundColor(.gray)
                                .rotationEffect(Angle(degrees: 90))
                                .padding(.leading, 6)
                            
                            Spacer(minLength: 0)
                            
                            TextField("deep", value: $focalculator.deep ,format: .number)
                                .font(.system(.title, design: .monospaced))
                                .keyboardType(.decimalPad)
                                .focused($keyboard)
                        }
                        .modifier(OilCalcComfort(edges: .vertical))
                        .bordered()
                        
                        TempStepper(title: "temprature of tank" ,temp: $focalculator.tankTemp)
                            .frame(height: 100)
                            .focused($keyboard)
                            .bordered()
                        
                        TempStepper(title: "ambiant temprature" ,temp: $focalculator.temp, min: -20)
                            .frame(height: 100)
                            .focused($keyboard)
                            .bordered()
                        
                        Button {
                            focalculator.calculate()
                        } label: {
                            Text("calculate")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .foregroundStyle(scheme == .dark ? .black : .white)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                        .tint(.oilish)
                        
                        HStack {
                            CalculatorButton(action: focalculator.total, title: "MR")
                            CalculatorButton(action: focalculator.popMemory, title: "MC")
                            CalculatorButton(action: focalculator.clearAll, title: "AC")
                        }
                        .tint(.oilish)
                        
                    }
                    .padding()
                    
                    
                    
                }
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Button("done") {
                                keyboard = false
                            }
                            Spacer(minLength: 0)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            DataSheetView(storages: focalculator.storages, ctses: focalculator.cts)
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .tint(.brown)
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            menuBuilder()
                            Divider()
                            Toggle(isOn: $focalculator.sixty) {
                                Text("in 60 degree")
                                    .bold()
                            }
                        } label: {
                            Text("Storage **\(focalculator.selectedStorage)**")
                                .font(.system(.body, design: .monospaced))
                        }
                    }
                }
                
            }
            .padding(.top, 10)
            .background()
            .navigationBarTitleDisplayMode(.inline)
        }
        .accentColor(Color.label)
        .onChange(of: selectedFile) { url in
            Task {
                await focalculator.getData(from: url)
            }
        }
    }
    
    @ViewBuilder
    private func menuBuilder() -> some View {
        Picker("storages", selection: $focalculator.selectedStorage) {
            ForEach(focalculator.storages) { storage in
                Text(storage.description)
                    .tag(Int(storage.id) ?? 1)
            }
        }
    }
}

#Preview {
    OilCalculatorView()
        .environmentObject(MessageManager())
        .environmentObject(FileServer.shared)
    
}
