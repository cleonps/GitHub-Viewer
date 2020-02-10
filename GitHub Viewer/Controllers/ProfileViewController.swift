//
//  ProfileViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 08/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        self.userDefaults.removeObject(forKey: UserDefaults.Keys.User)
        self.userDefaults.removeObject(forKey: UserDefaults.Keys.Password)
        UIView.setAnimationsEnabled(true)
        dismiss(animated: true)
    }
    
}
