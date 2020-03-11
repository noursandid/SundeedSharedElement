//
//  PresentationDelegate.swift
//  PresentationControllerHelper
//
//  Created by Nour Sandid on 3/6/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

class PresentationDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var duration: TimeInterval = 1
    var sharedElements: [(UIView, UIView?, Bool)] = []
    var interactor: UIPercentDrivenInteractiveTransition?
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissalAnimation(duration: duration, sharedElements: sharedElements)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimation(duration: duration, sharedElements: sharedElements)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor
    }
}
