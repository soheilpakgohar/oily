//
//  DataSheetDetailView.swift
//  PlantOverview
//
//  Created by soheil pakgohar on 5/24/23.
//

import SwiftUI

struct DataSheetDetailView: View {
    
    var data: any Hashable
    @State private var meterSelection = TankMetering.cm
    
    var body: some View {
        VStack {
            if let storage = data as? Storage {
                Picker("", selection: $meterSelection) {
                    ForEach(TankMetering.allCases) {
                        Text($0.rawValue.uppercased())
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.bottom)
                
                List {
                    ForEach(storage[meterSelection].indices, id: \.self) { index in
                        HStack {
                            Text(index.description)
                            Spacer(minLength: 0)
                            Text(storage[meterSelection][index], format: .number)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            } else if let arr = data as? [Double] {
                List {
                    ForEach(arr.indices, id: \.self) { index in
                        HStack {
                            Text(index.description)
                            Spacer(minLength: 0)
                            Text(arr[index].description)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding(.all)
        .navigationTitle(Text("values"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    enum TankMetering: String, CaseIterable, Identifiable {
        case cm, mm
        
        var id: String {
            self.rawValue
        }
    }
}

extension Storage {
    
    subscript(param: DataSheetDetailView.TankMetering) -> [Double] {
        switch param {
        case .cm:
            return self.cm
        default:
            return self.mm
        }
    }
}

#Preview {
    NavigationView {
        DataSheetDetailView(data: [Double]())
    }
}
