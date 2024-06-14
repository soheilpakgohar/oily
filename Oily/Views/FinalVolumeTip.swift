//
//  FinalVolumeTip.swift
//  Oily
//
//  Created by soheil pakgohar on 6/14/24.
//

import TipKit

@available(iOS 17.0, *)
struct FinalVolumeTip: Tip {
    
    var title: Text {
        Text("copy volume".capitalized)
    }
    
    var message: Text? {
        Text("you can double tap on volume to copy that if it is useful".capitalized)
    }
    
    var image: Image? {
        Image(systemName: "doc.on.doc")
    }
}
