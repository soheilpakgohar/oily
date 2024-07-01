//
//  OilCalculatorView.swift
//  PlantOverview
//
//  Created by soheil pakgohar on 4/12/23.
//

import SwiftUI
import TipKit

struct OilCalculatorView: View {
    
    @EnvironmentObject private var messageManager: MessageManager
    @EnvironmentObject private var focalculator: FuelOilCalculator
    @FocusState private var keyboard
    @Environment(\.displayScale) var ds
    @Environment(\.colorScheme) var scheme
    @AppStorage("selectedFile") private var selectedFile: URL?
    @State private var howitworksView = false
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
                    
                    
                    finalVolume()
                    
                }
                .bordered()
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .layoutPriority(1)
                
                
                ScrollView {
                   calculator()
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
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            DataSheetView(storages: focalculator.storages, ctses: focalculator.cts)
                        } label: {
                            Image(systemName: "info")
                                .imageScale(.medium)
                                .padding(8)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .disabled(selectedFile == nil)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            menuBuilder()
                            Divider()
                            Toggle(isOn: $focalculator.sixty) {
                                Text("In 60 Degree")
                                
                            }
                            
                        } label: {
                            Text("Storage **\(focalculator.selectedStorage)**")
                                .font(.system(.body, design: .monospaced))
                                .padding(8)
                                .background(.ultraThinMaterial, in: Capsule())
                        }
                        .disabled(selectedFile == nil)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            withAnimation {
                                focalculator.ambiantLockToTank.toggle()
                            }
                        } label: {
                            Image(systemName: focalculator.ambiantLockToTank ? "lock.fill" : "lock.open.fill")
                                .animation(.default, value: focalculator.ambiantLockToTank)
                                .imageScale(.medium)
                                .padding(.vertical,8)
                                .padding(.horizontal,10)
                                .background(.ultraThinMaterial, in: Capsule())
                        }
                        
                        
                    }
                }
            }
            .padding(.top)
            .background()
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationTitle(Text("Calculator"))
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $howitworksView, content: {
            HowitworksView()
        })
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
    
    @ViewBuilder
    private func calculator() -> some View {
        VStack(spacing: 15) {
            
            HStack {
                Image(systemName: "ruler")
                    .imageScale(.large)
                    .foregroundColor(.gray)
                    .rotationEffect(Angle(degrees: 90))
                    .frame(width: 50, height: 25)
                
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
            
            
            VStack {
                HStack {
                    CalculatorButton(action: focalculator.total, title: "MR")
                    CalculatorButton(action: focalculator.popMemory, title: "MC")
                    CalculatorButton(action: focalculator.clearAll, title: "AC")
                    
                    Button {
                        focalculator.calculate()
                    } label: {
                        Image(systemName: "equal")
                            .frame(minWidth: 45,maxHeight: .infinity)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .foregroundStyle(scheme == .dark ? .black : .white)
                            .background(Color.accentColor)
                            .clipShape(Capsule())
                    }
                }
                
                Button {
                    howitworksView.toggle()
                } label: {
                    Text("How it works?")
                        .underline()
                        .font(.footnote)
                }
                .tint(.gray)
                .padding(.top)
            }
            .padding()
        }
        .padding()
    }
    
    @ViewBuilder
    private func finalVolume() -> some View {
        if #available(iOS 17.0, *) {
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
                .popoverTip(FinalVolumeTip())
        } else {
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
    }
}

#Preview {
    let url = URL(string: "file:///Users/soheilpakgohar/Library/Developer/CoreSimulator/Devices/478F4C56-E0D7-43FA-9525-05E0E25671F6/data/Containers/Data/Application/567E4534-F698-4BAF-9419-AE17C7A2D876/Documents/B91AB2186470-isin.json")!
    FileServer.shared.existingFiles = [url]
    return OilCalculatorView()
        .environmentObject(MessageManager())
        .environmentObject(FileServer.shared)
        .environmentObject(FuelOilCalculator())
}
