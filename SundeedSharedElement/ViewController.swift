//
//  ViewController.swift
//  SundeedSharedElement
//
//  Created by Nour Sandid on 3/8/20.
//  Copyright © 2020 noursandid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var backgroundColor: UIColor = .blue
    @IBOutlet weak var viewtoAnimate: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
    }
    
    @IBAction func buttonPessed(_ sender: Any) {
        let secondViewController = SecondViewController(nibName: "SecondViewController", bundle: .main)
        SundeedPresentationController.shared.present(secondViewController)
            .onTopOf(self)
            .withDuration(0.3)
            .withSharedElement(from: self.viewtoAnimate, to: secondViewController.viewToAnimate)
            .withInteractionDirection(.down)
        .now()
    }
}
