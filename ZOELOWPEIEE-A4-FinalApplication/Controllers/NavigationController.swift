//
//  ViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 05/06/2023.
//

import UIKit

/// Custom navigation controller with additional configuration.
class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = UIColor(named: "BlueColor")
        // Do any additional setup after loading the view.
    }

}


