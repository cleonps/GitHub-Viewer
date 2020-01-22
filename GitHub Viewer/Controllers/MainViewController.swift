//
//  ViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 18/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

fileprivate enum Field: Int {
    case email = 1
    case password = 2
}

protocol LoginDelegate {
    func updateUsername(_ username: String)
}

class MainViewController: UIViewController {
    var delegate: LoginDelegate?
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupDelegates()
        setupTextFields()
        hideKeyboardOnTap()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if validateData() {
            NetworkManager.shared.login(email: emailTextField.text!, password: passwordTextField.text!)
        } else {
            presentSimpleAlert(title: "Error", message: "Por favor llene todos los campos")
        }
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let field = Field(rawValue: textField.tag) else { return true }
        
        switch field {
        case .email:
            passwordTextField.becomeFirstResponder()
        case .password:
            textField.resignFirstResponder()
        }
        
        return false
    }
}

extension MainViewController: NetworkManagerDelegate {
    
    func response<T: Codable>(dataModel: T, endpoint: Router, code: StatusCodes) {
        switch code {
        case .success, .accepted:
            let user = dataModel as! UserResponse
            presentSimpleAlert(title: "Sesión Iniciada", message: "Bienvenido \(user.login)") {
                self.delegate?.updateUsername(user.login)
                
//                let transition: CATransition = CATransition()
//                transition.duration = 0.5
//                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//                transition.type = CATransitionType.push
//                transition.subtype = CATransitionSubtype.fromBottom
//                self.view.window!.layer.add(transition, forKey: nil)
                self.dismiss(animated: true)
            }
        default:
            let error = dataModel as! ErrorResponse
            presentSimpleAlert(title: "Error", message: error.message)
        }
    }
    
    func unparseableResponse(error message: String, endpoint: Router, code: StatusCodes) {
        presentSimpleAlert(title: "Error", message: message)
    }
}
