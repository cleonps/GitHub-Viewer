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
    
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.buttonStyle()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        userDefaults.removeObject(forKey: .User)
        userDefaults.removeObject(forKey: .Password)
        UIView.setAnimationsEnabled(true)
        dismiss(animated: true)
    }
    
}
