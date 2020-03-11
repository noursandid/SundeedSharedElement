//
//  SecondViewController.swift
//  SundeedSharedElement
//
//  Created by Nour Sandid on 3/10/20.
//  Copyright © 2020 noursandid. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var viewToAnimate: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
