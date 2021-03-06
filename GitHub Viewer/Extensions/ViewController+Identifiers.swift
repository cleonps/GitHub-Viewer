//
//  ViewController+Identifiers.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 30/03/20.
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
        case gistDetail = "GistsDetails"
        
        // Gists
        case gistsList = "GistsList"
        case gistFile = "GistFile"
        
        // Repos
        case reposList = "ReposList"
        case repoFile = "RepoFile"
        
        // Profile
        case profile = "Profile"
    }
    
    /// Initiates the segue with the specified enumerated identifier
    public func performSegue(withIdentifier identifier: Segues) {
        performSegue(withIdentifier: identifier.rawValue, sender: nil)
    }
    
    /// Returns an instance of UIViewController subclass
    ///
    /// - Parameters:
    ///     - storyboard: The *name* of the storyboard in which the view is located.
    ///     - identifier: The *storyboard id* property of the view.
    ///     - controller: The *UIViewController subclass* associated with the view.
    ///     - presentation: The *UIModalPresentationStyle*, default value is .fullScreen
    public func instantiateVC<T: UIViewController>(storyboard: Storyboards, identifier: ViewIdentifiers, controller: T.Type, presentation: UIModalPresentationStyle? = .fullScreen) -> T? {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier.rawValue) as? T
        viewController?.modalPresentationStyle = presentation!
        
        return viewController
    }
}

