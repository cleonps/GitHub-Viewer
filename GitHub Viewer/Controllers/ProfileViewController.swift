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
    @IBOutlet var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.image = #imageLiteral(resourceName: "logo")
        logoutButton.buttonStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if profileImage.image == #imageLiteral(resourceName: "logo") {
            setupProfileImage()
        }
    }
    
    private func setupProfileImage() {
        guard let url = URL(string: userDefaults.value(forKey: .AvatarURL) as! String) else { return }
        
        do {
            profileImage.image = try UIImage(data: Data(contentsOf: url))
            profileImage.viewStyle(bgColor: .white)
        } catch (let e) {
            print("Error: \(e)")
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        userDefaults.removeAll()
        UIView.setAnimationsEnabled(true)
        dismiss(animated: true)
    }
    
}
