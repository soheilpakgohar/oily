//
//  HowitworksView.swift
//  Oily
//
//  Created by soheil pakgohar on 6/12/24.
//

import SwiftUI

struct HowitworksView: View {
    
    let howitworksItems: [HowitworksItem] = [
        .init(text: "first of first put the *deep* and *temprature* of tank and ambiant and hit the *equal* button", image: "1"),
        .init(text: "after seeing the result at the top, from the *storages* menu at the top left corner choose the next tank and repeat previus slide to calculate the volume", image: "4"),
        .init(text: "finaly after calculate all storages volumes hit the *MR* button to calculate the total volume of all storages. to repeat the process just hit the *MC* to make a fresh screen and memory", image: "5")
        
    ]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            TabView {
                ForEach(Array(howitworksItems.enumerated()), id: \.offset) { index, item in
                    ZStack {
                        item.color
                            .ignoresSafeArea()
                        
                        HowitworksItemView(item: item, index: index + 1)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .ignoresSafeArea()
         
            Button {
                dismiss()
            } label: {
                Image(systemName: "multiply")
                    .imageScale(.large)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .padding(.leading)
            }
            .position(CGPoint(x: 10.0, y: 10.0))
            .padding()
            .padding(.top)
        }
    }
}

struct HowitworksItemView: View {
    
    var item: HowitworksItem
    var index: Int
    
    var body: some View {
        VStack {
            Image(systemName: "\(index).circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.accentColor)
                .frame(width: 75)
                .padding(.top, 48)
            
            Spacer(minLength: 0)
            
            Image(item.image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 10)
                .frame(width: 250)
                .padding(.bottom)
            
            Text(item.text)
                .padding()
                .multilineTextAlignment(.leading)
            
            Spacer(minLength: 0)
        }
    }
}

struct HowitworksItem: Identifiable {
    var id: UUID = UUID()
    var text: LocalizedStringKey
    var image: String
    var color: Color = Color(uiColor: UIColor.secondarySystemBackground)
}

#Preview {
    HowitworksView()
}
