//
//  ViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 18/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit
import Alamofire

fileprivate enum Field: Int {
    case email = 1
    case password = 2
}

class MainViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    
    var shouldCallAPI = true
    
    @IBOutlet var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        view.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if checkIfUserExists() {
            let user = userDefaults.string(forKey: UserDefaults.Keys.User)!
            let password = userDefaults.string(forKey: UserDefaults.Keys.Password)!
            UIView.setAnimationsEnabled(false)
            NetworkManager.shared.authorization = HTTPHeader.authorization(username: user, password: password)
            performSegue(withIdentifier: .home)
        } else {
            view.isHidden = false
            setupTextFields()
            setupDelegates()
            loginButton.buttonStyle()
            hideKeyboardOnTap()
        }
    }
    
    override func dismissKeyboard() {
        super.dismissKeyboard()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            self.logoWidthConstraint.constant = 200
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton? = nil) {
        if shouldCallAPI {
            shouldCallAPI = false
            
            if validateData() {
                NetworkManager.shared.login(email: emailTextField.text!, password: passwordTextField.text!)
            } else {
                presentSimpleAlert(title: "Error", message: "Por favor llene todos los campos")
                shouldCallAPI = true
            }
        }
    }
    
    private func checkIfUserExists() -> Bool {
        guard let _ = userDefaults.string(forKey: UserDefaults.Keys.User),
              let _ = userDefaults.string(forKey: UserDefaults.Keys.Password) else { return false }
        return true
    }
    
    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        NetworkManager.shared.delegate = self
    }
    
    private func setupTextFields() {
        emailTextField.tag = Field.email.rawValue
        passwordTextField.tag = Field.password.rawValue
    }
    
    private func validateData() -> Bool {
        return emailTextField.text != "" && passwordTextField.text != ""
    }
    
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.logoWidthConstraint.constant = 1
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let field = Field(rawValue: textField.tag) else { return true }
        
        switch field {
        case .email:
            passwordTextField.becomeFirstResponder()
        case .password:
            textField.resignFirstResponder()
            loginButtonPressed()
            dismissKeyboard()
        }
        
        return false
    }
}

extension MainViewController: NetworkManagerDelegate {
    func response(withError error: String, endpoint: Router) {
        switch endpoint {
        case .login:
            shouldCallAPI = true
            presentSimpleAlert(title: "Error", message: error)
        default:
            break
        }
    }
    
    func response<T: Codable>(dataModel: T, endpoint: Router, code: StatusCodes) {
        switch code {
        case .success, .accepted:
            let userData = dataModel as! UserResponse
            self.shouldCallAPI = true
            presentSimpleAlert(title: "Sesión Iniciada", message: "Bienvenido \(userData.login)") {
                let user = userData.login
                let password = self.passwordTextField.text!
                let avatar = userData.avatar_url
                let name = userData.name
                let blog = userData.blog
                let location = userData.location
                let email = userData.email
                let publicRepos = userData.public_repos
                let publicGists = userData.public_gists
                let followers = userData.followers
                let following = userData.following
                
                // Save Profile Data
                self.userDefaults.setValue(user, forKey: .User)
                self.userDefaults.setValue(password, forKey: .Password)
                self.userDefaults.setValue(avatar, forKey: .AvatarURL)
                self.userDefaults.setValue(name, forKey: .Name)
                self.userDefaults.setValue(blog, forKey: .Blog)
                self.userDefaults.setValue(location, forKey: .Location)
                self.userDefaults.setValue(email, forKey: .Email)
                self.userDefaults.setValue(publicRepos, forKey: .PublicRepos)
                self.userDefaults.setValue(publicGists, forKey: .PublicGists)
                self.userDefaults.setValue(followers, forKey: .Followers)
                self.userDefaults.setValue(following, forKey: .Following)
                
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                
                self.performSegue(withIdentifier: .home)
            }
        default:
            let error = dataModel as! ErrorResponse
            presentSimpleAlert(title: "Error", message: error.message)
        }
    }
    
}
