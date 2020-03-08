//
//  DismissingAnimation {.swift
//  PresentationControllerHelper
//
//  Created by Nour Sandid on 3/6/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

class DismissalAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    private var duration: TimeInterval
    private var sharedElements: [(UIView, UIView?, Bool)]
    private var copySharedElements: [(UIView, UIView?, Bool)] = []
    private var copySharedElementsToMap: [UIView: UIView?] = [:]
    private var copySharedElementsFromMap: [UIView: UIView?] = [:]
    private var copyShareElementsFromCopyMap: [UIView: UIView] = [:]

    
    init(duration: TimeInterval,
         sharedElements: [(UIView, UIView?, Bool)]) {
        self.duration = duration
        self.sharedElements = sharedElements
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .from), let fromView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        let containerView = transitionContext.containerView
        toView.frame = containerView.frame
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        copySharedElements = sharedElements
            .map({ (fromView, toView, isDifferent) -> (UIView, UIView?, Bool) in
                guard var toViewCopy = toView?.snapshotView(afterScreenUpdates: true),
                var fromViewCopy = fromView.snapshotView(afterScreenUpdates: true) else {
                    return (fromView, toView, isDifferent)
                }
                
                if let toViewImageView = toView as? UIImageView {
                    let imageView = UIImageView(image: toViewImageView.image)
                    imageView.contentMode = toViewImageView.contentMode
                    toViewCopy = imageView
                }
                
                if let fromViewImageView = fromView as? UIImageView {
                    let imageView = UIImageView(image: fromViewImageView.image)
                    imageView.contentMode = fromViewImageView.contentMode
                    fromViewCopy = imageView
                }
                
                if let toView = toView, let superView = toView.superview {
                    toViewCopy.frame = superView.convert(toView.frame, to: transitionContext.containerView)
                    fromViewCopy.frame = superView.convert(toView.frame, to: transitionContext.containerView)
                }
                copySharedElementsToMap[toViewCopy] = toView
                copyShareElementsFromCopyMap[toViewCopy] = fromViewCopy
                copySharedElementsFromMap[toViewCopy] = fromView
                return (fromView, toViewCopy, isDifferent)
        })

        copySharedElements.forEach { (view1, view2, isDifferent) in
            if let view2 = view2 {
                if let fromViewCopy = copyShareElementsFromCopyMap[view2] {
                    fromViewCopy.alpha = 0
                    fromViewCopy.isHidden = !isDifferent
                    containerView.addSubview(fromViewCopy)
                }
                containerView.addSubview(view2)
                copySharedElementsToMap[view2]??.alpha = 0
                copySharedElementsFromMap[view2]??.alpha = 0
            }
        }
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.alpha = 0
            self.copySharedElements.forEach { (view1, view2, isDifferent) in
                if let superView = view1.superview {
                    view2?.frame = superView.convert(view1.frame, to: transitionContext.containerView)
                    if isDifferent, let view2 = view2 {
                        self.copyShareElementsFromCopyMap[view2]?.frame =
                            superView.convert(view1.frame, to: transitionContext.containerView)
                        self.copyShareElementsFromCopyMap[view2]?.alpha = 1
                        view2.alpha = 0
                    }
                }
            }
        }, completion: { _ in
            self.copySharedElements.forEach { (view1, view2, isDifferent) in
                if let view2 = view2 {
                    self.copySharedElementsToMap[view2]??.alpha = 1
                    self.copySharedElementsFromMap[view2]??.alpha = 1
                    view2.removeFromSuperview()
                    self.copyShareElementsFromCopyMap[view2]?.removeFromSuperview()
                }
            }
            transitionContext
                .completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
