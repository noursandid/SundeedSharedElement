//
//  NavigationDelegate.swift
//  PresentationControllerHelper
//
//  Created by Nour Sandid on 3/7/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

class NavigationDelegate: NSObject, UINavigationControllerDelegate {
    var duration: TimeInterval = 1
    var sharedElements: [(UIView, UIView?, Bool)] = []
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return PresentationAnimation(duration: duration,
                                         sharedElements: sharedElements)
        case .pop:
            return DismissalAnimation(duration: duration,
                                      sharedElements: sharedElements)
        default:
            return nil
        }
    }
}
