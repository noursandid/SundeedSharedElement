//
//  PresentationControllerHelper.swift
//  PresentationControllerHelper
//
//  Created by Nour Sandid on 3/6/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

public class AnimationHelper {
    fileprivate var duration: TimeInterval = 3
    fileprivate var rootViewController: UIViewController?
    fileprivate var presentedViewController: UIViewController?
    fileprivate var pushedViewController: UIViewController?
    fileprivate var sharedElements: [(UIView, UIView?, Bool)] = []
    
    fileprivate  let presentationDelegate = PresentationDelegate()
    fileprivate let navigationDelegate = NavigationDelegate()
    
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

public class NavigationDelegateHelper: AnimationHelper {
    public static let shared = NavigationDelegateHelper()

    @discardableResult
    func push(_ viewController: UIViewController) -> Self {
        pushedViewController = viewController
        pushedViewController?.loadViewIfNeeded()
        return self
    }
}
