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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let viewController = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
            viewController.backgroundColor = .green
            SundeedPresentationController.shared.present(viewController)
            .onTopOf(self)
            .withDuration(3)
                
            .now()
        }
    }


}

