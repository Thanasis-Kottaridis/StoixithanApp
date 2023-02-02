//
//  UINavigationController_Ext.swift
//  Presentation
//
//  Created by thanos kottaridis on 29/1/23.
//

import UIKit

extension UINavigationController {
    public func addTransition(transitionType type: CATransitionType = CATransitionType.push, duration: CFTimeInterval = 0.5) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType(rawValue: type.rawValue)
        self.view.layer.add(transition, forKey: nil)
    }
}
