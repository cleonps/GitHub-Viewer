//
//  ViewController+Utilities.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 18/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public enum Segues: String {
        case home = "loginHomeSegue"
        case gistFileList = "gistFilesSegue"
        case gistFile = "gistFileSegue"
        case repoContents = "repoContentsSegue"
        case repoFile = "repoFileSegue"
    }
    
    public enum Storyboards: String {
        case login = "Main"
        case home = "Home"
        case gists = "Gists"
        case profile = "Profile"
        case repos = "Repos"
    }
    
    public enum ViewIdentifiers: String {
        // Main
        case login = "Login"
        
        // Home
        case gistTabBar = "GistsTabBar"
        
        // Gists
        case gistsList = "GistsList"
        
        // Repos
        case reposList = "ReposList"
        
        // Profile
        case profile = "Profile"
    }
    
    func performSegue(withIdentifier identifier: Segues) {
        performSegue(withIdentifier: identifier.rawValue, sender: nil)
    }
    
    /// Returns an instance of UIViewController subclass
    ///
    /// - Parameters:
    ///     - storyboard: The *name* of the storyboard in which the view is located.
    ///     - identifier: The *storyboard id* property of the view.
    ///     - controller: The *UIViewController subclass* associated with the view.
    ///     - presentation: The *UIModalPresentationStyle*, default value is .fullScreen
    func instantiateVC<T: UIViewController>(storyboard: Storyboards, identifier: ViewIdentifiers, controller: T.Type, presentation: UIModalPresentationStyle? = .fullScreen) -> T? {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier.rawValue) as? T
        viewController?.modalPresentationStyle = presentation!
        
        return viewController
    }
    
    /// Presents a simple Alert with only one option
    ///
    /// - Parameters:
    ///     - title: The *title* of the alert.
    ///     - message: The *message* that the alert displays.
    ///     - actionHandler: The *closure* executed when the button is pressed.
    func presentSimpleAlert(title: String, message: String, actionHandler: (() -> Void)? = nil) {
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
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
