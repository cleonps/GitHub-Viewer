//
//  UIView+Styles.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 11/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

extension UIView {
    
    public func buttonStyle() {
        let fancyButton = self.layer
        fancyButton.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        fancyButton.shadowOffset = CGSize(width: 0.0, height: 2.0)
        fancyButton.shadowOpacity = 1.0
        fancyButton.shadowRadius = 0.0
        fancyButton.masksToBounds = false
        fancyButton.cornerRadius = 10
    }
    
    public func buttonStyle(bgColor color: UIColor) {
        buttonStyle()
        self.backgroundColor = color
    }
    
    public func viewStyle() {
        let fancyView = self.layer
        fancyView.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        fancyView.shadowOffset = CGSize(width: 0, height: 3)
        fancyView.shadowOpacity = 1.0
        fancyView.shadowRadius = 2.0
        fancyView.masksToBounds = false
        fancyView.cornerRadius = 15
    }
    
    public func viewStyle(bgColor color: UIColor) {
        viewStyle()
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
