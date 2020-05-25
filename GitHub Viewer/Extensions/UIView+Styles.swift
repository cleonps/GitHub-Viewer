//
//  UIView+Styles.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 11/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

extension UIView {
    
    public func roundButton() {
        let fancyButton = self.layer
        fancyButton.masksToBounds = false
        fancyButton.cornerRadius = 10
    }
    
    public func roundButton(bgColor color: UIColor) {
        roundButton()
        self.backgroundColor = color
    }
    
    public func roundView() {
        let fancyView = self.layer
        fancyView.masksToBounds = false
        fancyView.cornerRadius = 5
    }
    
    public func roundView(bgColor color: UIColor) {
        roundView()
        self.backgroundColor = color
    }
    
    public func animateButton() {
        let animatedView = self.layer
        UIView.animate(withDuration: 0.1, animations: {
            animatedView.transform = CATransform3DMakeScale(0.8, 0.8, 1)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                animatedView.transform = CATransform3DMakeScale(1, 1, 1)
            })
        }
    }
    
}
