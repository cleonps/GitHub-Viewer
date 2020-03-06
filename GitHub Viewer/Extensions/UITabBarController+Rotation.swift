//
//  UITabBarController+Rotation.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 06/03/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

extension UITabBarController {
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        let shouldRotate = selectedViewController?.children.last is GistFileContentViewController ||
            selectedViewController?.children.last is RepoFileViewController
        if shouldRotate {
            return .allButUpsideDown
        } else {
            return .portrait
        }
    }
}
