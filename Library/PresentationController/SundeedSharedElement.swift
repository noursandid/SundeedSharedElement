//
//  PresentationControllerHelper.swift
//  PresentationControllerHelper
//
//  Created by Nour Sandid on 3/6/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

class SundeedInteractor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}



public class AnimationHelper {
    enum Direction {
        case up
        case down
        case left
        case right
    }
    fileprivate var duration: TimeInterval = 3
    fileprivate let percentThreshold:CGFloat = 0.5
    fileprivate var rootViewController: UIViewController?
    fileprivate var presentedViewController: UIViewController?
    fileprivate var pushedViewController: UIViewController?
    fileprivate var sharedElements: [(UIView, UIView?, Bool)] = []
    
    fileprivate  let presentationDelegate = PresentationDelegate()
    fileprivate let navigationDelegate = NavigationDelegate()
    fileprivate let interactor = SundeedInteractor()
    fileprivate var direction: Direction?
    
    @discardableResult
    func withSharedElement(from: UIView, to: UIView?) -> Self {
        sharedElements.append((from, to, false))
        return self
    }
    
    @discardableResult
    func withDuration(_ duration: TimeInterval) -> Self {
        self.duration = duration
        return self
    }
    
    @discardableResult
    func onTopOf(_ viewController: UIViewController) -> Self {
        self.rootViewController = viewController
        return self
    }
    
    @discardableResult
    func withInteractionDirection(_ direction: Direction) -> Self {
        self.direction = direction
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(SundeedPresentationController.shared.panGestureHandler(panGesture:)))
        presentedViewController?.view.addGestureRecognizer(panGesture)
        pushedViewController?.view.addGestureRecognizer(panGesture)
        presentationDelegate.interactor = interactor
        navigationDelegate.interactor = interactor
        return self
    }
    
    func now(completion: (()->Void)? = nil) {
        guard presentedViewController == nil || pushedViewController == nil else {
            fatalError("Attempted to present and push")
        }
        if let presentedViewController = presentedViewController {
            presentationDelegate.sharedElements = self.sharedElements
            presentationDelegate.duration = duration
            rootViewController?.present(presentedViewController,
                                        animated: true,
                                        completion: completion)
            sharedElements = []
        } else if let pushedViewController = pushedViewController {
            navigationDelegate.sharedElements = sharedElements
            navigationDelegate.duration = duration
            rootViewController?.navigationController?.delegate = navigationDelegate
            rootViewController?.navigationController?
                .pushViewController(pushedViewController,
                                    animated: true)
            sharedElements = []
        }
    }
    
    fileprivate func calculateProgress(translationInView:CGPoint, viewBounds:CGRect, direction:Direction) -> CGFloat {
        let pointOnAxis:CGFloat
        let axisLength:CGFloat
        switch direction {
        case .up, .down:
            pointOnAxis = translationInView.y
            axisLength = viewBounds.height/3
        case .left, .right:
            pointOnAxis = translationInView.x
            axisLength = viewBounds.width
        }
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis:Float
        let positiveMovementOnAxisPercent:Float
        switch direction {
        case .right, .down:
            positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        case .up, .left:
            positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
            return CGFloat(-positiveMovementOnAxisPercent)
        }
    }
    
    fileprivate func mapGestureStateToInteractor(gestureState:UIGestureRecognizer.State, progress:CGFloat, triggerSegue: () -> Void){
        switch gestureState {
        case .began:
            interactor.hasStarted = true
            triggerSegue()
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    @objc func panGestureHandler(panGesture: UIPanGestureRecognizer) {
        guard let viewController = presentedViewController ?? pushedViewController,
        let direction = direction else {
            return
        }
        let translation = panGesture.translation(in: viewController.view)
        let progress = calculateProgress(
            translationInView: translation,
            viewBounds: viewController.view.bounds,
            direction: direction
        )
        mapGestureStateToInteractor(
            gestureState: panGesture.state,
            progress: progress){
                if let viewController = self.presentedViewController {
                    viewController.dismiss(animated: true, completion: nil)
                } else if let viewController = self.pushedViewController {
                    viewController.navigationController?.popViewController(animated: true)
                }
        }
    }
}
public class SundeedPresentationController: AnimationHelper {
    public static let shared = SundeedPresentationController()
    
    @discardableResult
    func withDifferentElement(from: UIView, to: UIView?) -> Self {
        sharedElements.append((from, to, true))
        return self
    }
    
    @discardableResult
    func present(_ viewController: UIViewController) -> Self {
        presentedViewController = viewController
        if let navigationController = presentedViewController as? UINavigationController {
            navigationController.viewControllers.first?.loadView()
        }
        presentedViewController?.loadViewIfNeeded()
        presentedViewController?.modalPresentationStyle = .fullScreen
        presentedViewController?.transitioningDelegate = presentationDelegate
        
        return self
    }
     
}

public class SundeedNavigationDelegate: AnimationHelper {
    public static let shared = SundeedNavigationDelegate()
    @discardableResult
    func push(_ viewController: UIViewController) -> Self {
        pushedViewController = viewController
        pushedViewController?.loadViewIfNeeded()
        return self
    }
}
