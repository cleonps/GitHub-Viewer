//
//  ViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 18/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SafariServices

class MainViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    let keychain = KeychainWrapper.standard
    private var shouldOAUTH = true
    
    @IBOutlet var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(getToken), name: NSNotification.Name(rawValue: "CodeObtained"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        view.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if checkIfUserExists() {
            let token = keychain.string(forKey: .token)!
            NetworkManager.shared.authorization = HTTPHeader.authorization(bearerToken: token)
            performSegue(withIdentifier: .home)
        } else {
            view.isHidden = false
            NetworkManager.shared.delegate = self
            loginButton.roundButton()
            hideKeyboardOnTap()
        }
    }
    
    @objc func getToken() {
        if let code = keychain.string(forKey: .code),
            let client = Secrets.GitHub.clientId,
            let secret = Secrets.GitHub.clientSecret {
            NetworkManager.shared.getToken(client: client, secret: secret, code: code)
        } else {
            shouldOAUTH = true
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton? = nil) {
        if let url = fetchOAuthURL(), shouldOAUTH {
            shouldOAUTH = false
            let safariVC = SFSafariViewController(url: url)
            
            present(safariVC, animated: true)
        }
    }
    
    private func fetchOAuthURL() -> URL? {
        if let clientID = Secrets.GitHub.clientId {
            let bundle = "GHViewer://oauth"
            let scope = "repo gist"
            let baseURL = "https://github.com/login/oauth/authorize/"
            let url = URL(string: "\(baseURL)?client_id=\(clientID)&redirect_uri=\(bundle.urlEncoded)&scope=\(scope.urlEncoded)")!
            
            return url
        } else {
            return nil
        }
    }
    
    private func checkIfUserExists() -> Bool {
        let userIsSet = userDefaults.string(forKey: UserDefaults.Keys.user) != nil
        let tokenIsSet = keychain.string(forKey: .token) != nil
        return userIsSet && tokenIsSet
    }
    
}

extension MainViewController: NetworkManagerDelegate {
    func response(withError error: String, endpoint: Router) {
        switch endpoint {
        case .login:
            shouldOAUTH = true
            presentSimpleAlert(title: "Error al iniciar sesión", message: error)
        case .getToken:
            shouldOAUTH = true
            presentSimpleAlert(title: "Error al obtener token", message: error)
        default:
            break
        }
    }
    
    func response<T: Codable>(dataModel: T, endpoint: Router, code: StatusCodes) {
        switch code {
        case .success, .accepted:
            switch endpoint {
            case .getToken:
                guard let authorization = dataModel as? Authorization else { return }
                
                if keychain.set(authorization.access_token, forKey: .token) {
                    NetworkManager.shared.login(token: authorization.access_token)
                }
                
            case .login:
                guard let userData = dataModel as? UserData else { return }
                
                shouldOAUTH = true
                
                let user = userData.login
                let avatar = userData.avatar_url
                let name = userData.name
                let blog = userData.blog
                let location = userData.location
                let email = userData.email
                let publicRepos = userData.public_repos
                let publicGists = userData.public_gists
                let followers = userData.followers
                let following = userData.following
                
                // Save profile data
                self.userDefaults.setValue(user, forKey: .user)
                self.userDefaults.setValue(avatar, forKey: .avatarURL)
                self.userDefaults.setValue(name, forKey: .name)
                self.userDefaults.setValue(blog, forKey: .blog)
                self.userDefaults.setValue(location, forKey: .location)
                self.userDefaults.setValue(email, forKey: .email)
                self.userDefaults.setValue(publicRepos, forKey: .publicRepos)
                self.userDefaults.setValue(publicGists, forKey: .publicGists)
                self.userDefaults.setValue(followers, forKey: .followers)
                self.userDefaults.setValue(following, forKey: .following)
                
                self.performSegue(withIdentifier: .home)
                
            default:
                break
            }
            
        default:
            shouldOAUTH = true
            guard let error = dataModel as? ErrorResponse else { return }
            presentSimpleAlert(title: "Error", message: error.message)
        }
    }
    
}
