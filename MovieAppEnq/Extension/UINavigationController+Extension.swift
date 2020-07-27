//
//  UINavigationController+Extension.swift
//  MovieAppEnq
//
//  Created by Birbay on 27.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit

public extension UINavigationController {
    func pop(transitionType type: String = CATransitionType.fade.rawValue,
             transitionsubtype subtype: String = CATransitionSubtype.fromRight.rawValue,
             duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.popViewController(animated: false)
    }

    func push(viewController vc: UIViewController,
              transitionType type: String = CATransitionType.fade.rawValue,
              transitionsubtype subtype: String = CATransitionSubtype.fromRight.rawValue,
              duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.pushViewController(vc, animated: false)
    }

    private func addTransition(transitionType type: String = CATransitionType.fade.rawValue,
                               transitionsubtype subtype: String = CATransitionSubtype.fromRight.rawValue,
                               duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType(rawValue: type)
        transition.subtype = CATransitionSubtype(rawValue: subtype)
        self.view.layer.add(transition, forKey: nil)
    }
}
