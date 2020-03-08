//
//  PresentingAnimation.swift
//  PresentationControllerHelper
//
//  Created by Nour Sandid on 3/6/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

class PresentationAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    private var duration: TimeInterval
    private var sharedElements: [(UIView, UIView?, Bool)]
    private var copySharedElements: [(UIView, UIView?, Bool)] = []
    private var copyShareElementsToMap: [UIView: UIView?] = [:]
    private var copyShareElementsToCopyMap: [UIView: UIView] = [:]
    private var copyShareElementsFromMap: [UIView: UIView?] = [:]
    
    init(duration: TimeInterval,
         sharedElements: [(UIView, UIView?, Bool)]) {
        self.duration = duration
        self.sharedElements = sharedElements
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext
                .completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        let containerView = transitionContext.containerView
        toView.frame = containerView.frame
        containerView.addSubview(toView)
        toView.alpha = 0
        
        copySharedElements = sharedElements
            .map({ (fromView, toView, isDifferent) -> (UIView, UIView?, Bool) in
                guard var fromViewCopy = fromView.snapshotView(afterScreenUpdates: false),
                    var toViewCopy = toView?.snapshotView(afterScreenUpdates: true) else {
                        return (fromView, toView, isDifferent)
                }
                if let fromViewImageView = fromView as? UIImageView {
                    let imageView = UIImageView(image: fromViewImageView.image)
                    imageView.contentMode = fromViewImageView.contentMode
                    fromViewCopy = imageView
                }
                if let toViewImageView = toView as? UIImageView {
                    let imageView = UIImageView(image: toViewImageView.image)
                    imageView.contentMode = toViewImageView.contentMode
                    toViewCopy = imageView
                }
                
                if let superView = fromView.superview {
                    fromViewCopy.frame = superView.convert(fromView.frame, to: containerView)
                    toViewCopy.frame = superView.convert(fromView.frame, to: containerView)
                }
                
                copyShareElementsToMap[fromViewCopy] = fromView
                copyShareElementsToCopyMap[fromViewCopy] = toViewCopy
                copyShareElementsFromMap[fromViewCopy] = toView
                
                return (fromViewCopy, toView, isDifferent)
            })
        
        copySharedElements.forEach { (view1, view2, isDifferent) in
            if let toViewCopy = copyShareElementsToCopyMap[view1] {
                toViewCopy.alpha = 0
                toViewCopy.isHidden = !isDifferent
                containerView.addSubview(toViewCopy)
            }
            containerView.addSubview(view1)
            copyShareElementsToMap[view1]??.alpha = 0
            copyShareElementsFromMap[view1]??.alpha = 0
        }
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.alpha = 1
            self.copySharedElements.forEach { (view1, view2, isDifferent) in
                if let superView = view2?.superview, let view2 = view2 {
                    view1.frame = superView.convert(view2.frame, to: transitionContext.containerView)
                    if isDifferent {
                        self.copyShareElementsToCopyMap[view1]?.frame =
                            superView.convert(view2.frame, to: transitionContext.containerView)
                        self.copyShareElementsToCopyMap[view1]?.alpha = 1
                        view1.alpha = 0
                    }
                }
            }
        }, completion: { _ in
            self.copySharedElements.forEach { (view1, view2, isDifferent) in
                self.copyShareElementsToMap[view1]??.alpha = 1
                self.copyShareElementsFromMap[view1]??.alpha = 1
                view1.removeFromSuperview()
                self.copyShareElementsToCopyMap[view1]?.removeFromSuperview()
            }
            transitionContext
                .completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}
