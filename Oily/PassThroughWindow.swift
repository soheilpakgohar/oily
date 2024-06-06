//
//  PassThroughWindow.swift
//  Oily
//
//  Created by soheil pakgohar on 6/5/24.
//

import UIKit

class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else {return nil}
        return rootViewController?.view == view ? nil : view
    }
}
