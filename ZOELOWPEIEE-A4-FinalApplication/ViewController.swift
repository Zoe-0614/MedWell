//
//  ViewController.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 19/04/2023.
//

import UIKit

/// A custom view controller class.
class ViewController: UIViewController {
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

/// An extension to UIViewController for displaying an alert message.
extension UIViewController {

    ///Displays an alert message with the specified title and message.
    /// - Parameters:
    ///    - title: The title of the alert.
    ///    - message: The message content of the alert.
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: "Dismiss",
            style: .default,
            handler: nil
        ))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
