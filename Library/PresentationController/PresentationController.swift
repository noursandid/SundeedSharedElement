//
//  PresentationController.swift
//  PresentationControllerHelper
//
//  Created by Nour Sandid on 3/6/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return containerView.frame
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
