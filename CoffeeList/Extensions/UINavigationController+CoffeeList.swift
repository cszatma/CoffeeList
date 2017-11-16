//
//  Extensions.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-10-06.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func present(viewController: UIViewController, animationType: AnimationType?, duration: CFTimeInterval = 0.5) {
        guard animationType != .push else {
            pushViewController(viewController, animated: true)
            return
        }
        
        if let type = animationType {
            view.layer.add(createTransition(type: type, duration: duration), forKey: nil)
        }
        
        pushViewController(viewController, animated: false)
    }
    
    @discardableResult
    func popViewController(animationType: AnimationType?, duration: CFTimeInterval = 0.5) -> UIViewController? {
        guard animationType != .push else {
            return popViewController(animated: true)
        }
        
        if let type = animationType {
            view.layer.add(createTransition(type: type, duration: duration), forKey: nil)
        }
        
        return popViewController(animated: false)
    }
    
    private func createTransition(type: AnimationType, duration: CFTimeInterval) -> CATransition {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = type.rawValue
        return transition
    }
    
}
