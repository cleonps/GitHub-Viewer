//
//  ViewController+Utilities.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 18/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Presents a simple Alert with only one option
    ///
    /// - Parameters:
    ///     - title: The *title* of the alert.
    ///     - message: The *message* that the alert displays.
    ///     - actionHandler: The *closure* executed when the button is pressed.
    public func presentSimpleAlert(title: String, message: String, actionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            if actionHandler != nil {
                actionHandler!()
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    /// Hides the keyboard when the diplay is tapped
    public func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
