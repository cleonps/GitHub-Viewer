//
//  ProfileViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 08/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ProfileViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    let keychain = KeychainWrapper.standard
    
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var blogLabel: UILabel!
    @IBOutlet var publicReposLabel: UILabel!
    @IBOutlet var publicGistsLabel: UILabel!
    @IBOutlet var followingLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.image = #imageLiteral(resourceName: "logo")
        logoutButton.roundButton()
        setupUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if profileImage.image == #imageLiteral(resourceName: "logo") {
            setupProfileImage()
        }
        
        let token = keychain.string(forKey: .token)!
        NetworkManager.shared.delegate = self
        NetworkManager.shared.login(token: token)
    }
    
    private func setupProfileImage() {
        let stringURL = (userDefaults.value(forKey: .avatarURL) as? String) ?? ""
        guard let url = URL(string: stringURL) else { return }
        
        do {
            profileImage.image = try UIImage(data: Data(contentsOf: url))
            profileImage.roundView(bgColor: .white)
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    private func setupUserInfo() {
        userNameLabel.text = userDefaults.value(forKey: .name) as? String
        
        if let location = setupUserDefault(forKey: .location) {
            locationLabel.text = location as? String
            locationLabel.isHidden = false
        } else {
            locationLabel.isHidden = true
        }
        
        if let email = setupUserDefault(forKey: .email) {
            emailLabel.text = email as? String
            locationLabel.isHidden = false
        } else {
            emailLabel.isHidden = true
        }
        
        if let blog = setupUserDefault(forKey: .blog) {
            blogLabel.text = blog as? String
            locationLabel.isHidden = false
        } else {
            blogLabel.isHidden = true
        }
        
        if let publicRepos = userDefaults.value(forKey: .publicRepos),
            let publicGists = userDefaults.value(forKey: .publicGists) {
            let repos = publicRepos as? Int
            let gists = publicGists as? Int
            publicReposLabel.text = "Repos: \(repos ?? 0)"
            publicGistsLabel.text = "Gists: \(gists ?? 0)"
        }
        
        if let following = userDefaults.value(forKey: .following),
            let followers = userDefaults.value(forKey: .followers) {
            let following = following as? Int
            let followers = followers as? Int
            followingLabel.text = "Siguiendo: \(following ?? 0)"
            followersLabel.text = "Seguidores: \(followers ?? 0)"
        }
        
    }
    
    private func setupUserDefault(forKey key: UserDefaults.Keys) -> Any? {
        if let value = userDefaults.value(forKey: key) {
            let string = (value as? String) ?? ""
            let number = (value as? Int) ?? 0
            if string != "" || number != 0 {
                return value
            }
        }
        
        return nil
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        keychain.removeAllKeys()
        userDefaults.removeAll()
        UIView.setAnimationsEnabled(true)
        dismiss(animated: true)
    }
    
}

extension ProfileViewController: NetworkManagerDelegate {
    func response(withError error: String, endpoint: Router) {
        return
    }
    
    func response<T: Codable>(dataModel: T, endpoint: Router, code: StatusCodes) {
        switch code {
        case .success, .accepted:
            switch endpoint {
            case .login:
                guard let userData = dataModel as? UserData else { return }
                
                let name = userData.name
                let blog = userData.blog
                let location = userData.location
                let email = userData.email
                let publicRepos = userData.public_repos
                let publicGists = userData.public_gists
                let followers = userData.followers
                let following = userData.following
                
                // Save Profile Data
                userDefaults.setValue(name, forKey: .name)
                userDefaults.setValue(blog, forKey: .blog)
                userDefaults.setValue(location, forKey: .location)
                userDefaults.setValue(email, forKey: .email)
                userDefaults.setValue(publicRepos, forKey: .publicRepos)
                userDefaults.setValue(publicGists, forKey: .publicGists)
                userDefaults.setValue(followers, forKey: .followers)
                userDefaults.setValue(following, forKey: .following)
                
                setupUserInfo()
            default:
                break
            }
        default:
            break
        }
    }
}
