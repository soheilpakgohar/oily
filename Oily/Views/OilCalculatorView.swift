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
    @AppStorage("selectedFile") private var selectedFile: URL?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    Text(focalculator.memory.map {String(describing: $0)}.joined(separator: ","))
                        .font(.caption)
                        .bold()
                        .lineLimit(1)
                        .padding(8)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    TextField("Liter", value: $focalculator.liter, format: .number)
                        .font(.system(size: 68, design: .monospaced))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .disabled(true)
                        .padding([.vertical , .leading])
                        .contentShape(Rectangle())
                        .onTapGesture(count: 2, perform: {
                            guard focalculator.liter != 0.0 else {return}
                            UIPasteboard.general.string = String(describing: focalculator.liter)
                            messageManager.showMessage(Toast(title: "Coppied", icon: "doc.on.doc"))
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
                            
                            TextField("Deep", value: $focalculator.deep ,format: .number)
                                .font(.system(.title, design: .monospaced))
                                .keyboardType(.decimalPad)
                                .focused($keyboard)
                        }
                        .modifier(OilCalcComfort(edges: .vertical, padding: 10))
                        .bordered()
                        
                        TempStepper(title: "Temprature of Tank" ,temp: $focalculator.tankTemp)
                            .focused($keyboard)
                            .bordered()
                        
                        if !focalculator.ambiantLockToTank {
                            TempStepper(title: "Ambiant Temprature" ,temp: $focalculator.temp, min: -20)
                                .frame(height: 100)
                                .focused($keyboard)
                                .bordered()
                        }
                        
                        /*Button {
                            focalculator.calculate()
                        } label: {
                            Text("Calculate")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .foregroundStyle(scheme == .dark ? .black : .white)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                        .tint(.oilish)*/
                        
                        HStack {
                            VStack {
                                CalculatorButton(action: focalculator.total, title: "MR")
                                CalculatorButton(action: focalculator.popMemory, title: "MC")
                                CalculatorButton(action: focalculator.clearAll, title: "AC")
                            }
                            .tint(Color.gray)
                            Button {
                                focalculator.calculate()
                            } label: {
                                Image(systemName: "equal")
                                    .frame(minWidth: 45,maxHeight: .infinity)
                                    .padding(.vertical, 8)
                                    .foregroundStyle(scheme == .dark ? .black : .white)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.oilish)
                        }
                        
                        
                        
                        
                    }
                    .padding()
                    
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
                                Text("In 60 Degree")
                                    
                            }
                            
                            Toggle(isOn: $focalculator.ambiantLockToTank.animation()) {
                                Text("Ambiant Lock to Tank")
                            }
                            
                        } label: {
                            Text("Storage **\(focalculator.selectedStorage)**")
                                .font(.system(.body, design: .monospaced))
                                .padding(8)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .padding(.top, 10)
            .background()
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
        }
        .accentColor(Color.label)
        .onChange(of: selectedFile) { url in
            guard let url else {return}
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
    let url = URL(string: "file:///Users/soheilpakgohar/Library/Developer/CoreSimulator/Devices/478F4C56-E0D7-43FA-9525-05E0E25671F6/data/Containers/Data/Application/567E4534-F698-4BAF-9419-AE17C7A2D876/Documents/B91AB2186470-isin.json")!
    FileServer.shared.existingFiles = [url]
    return OilCalculatorView()
            .environmentObject(MessageManager())
            .environmentObject(FileServer.shared)
    
}
