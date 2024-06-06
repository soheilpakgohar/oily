//
//  DataSheetView.swift
//  PlantOverview
//
//  Created by soheil pakgohar on 5/24/23.
//

import SwiftUI

struct DataSheetView: View {
    
    var storages: [Storage]
    var ctses: [Double]
    
    var body: some View {
        List {
            
            Section {
                ForEach(storages) { storage in
                    NavigationLink(destination: {
                        DataSheetDetailView(data: storage)
                    }) {
                        Text("datasheet for tank NO.\(storage.id)")
                    }
                }
            } header: {
                Text("tank's datasheets")
            }
            .textCase(.none)
            
            Section {
                NavigationLink(destination: {
                    DataSheetDetailView(data: ctses)
                }) {
                    Text("CTS table")
                }
            } header: {
                Text("other tables")
            }
            .textCase(.none)
        }
        .navigationTitle(Text("datasheets"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        DataSheetView(storages: [Storage](), ctses: [Double]())
    }
    .accentColor(Color.label)
}
