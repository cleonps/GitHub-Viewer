//
//  RepoFileViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 12/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit
import Highlightr

class RepoFileViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    lazy var user = userDefaults.string(forKey: UserDefaults.Keys.user)!
    var repo = ""
    var fileName = ""
    var file = RepoFileContent()
    
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var contentImage: UIImageView!
    @IBOutlet var bottomTextViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = fileName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let kbObserver = UIResponder.keyboardWillShowNotification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: kbObserver, object: nil)
        hideKeyboardOnTap()
        
        NetworkManager.shared.delegate = self
        if file.content == nil {
            NetworkManager.shared.getRepoFileContent(user: user, repo: repo, file: fileName)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomTextViewConstraint.constant = keyboardHeight - ((self.navigationController?.view.subviews[1].bounds.height) ?? 0)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func dismissKeyboard() {
        super.dismissKeyboard()
        
        bottomTextViewConstraint.constant = 10
    }
}

extension RepoFileViewController: NetworkManagerDelegate {
    func response(withError error: String, endpoint: Router) {
        switch endpoint {
        case .getRepoFileContent:
            presentSimpleAlert(title: "Error", message: error)
        default:
            break
        }
    }
    
    func response<T: Codable>(dataModel: T, endpoint: Router, code: StatusCodes) {
        switch endpoint {
        case .getRepoFileContent:
            switch code {
            case .success, .accepted:
                file = (dataModel as? RepoFileContent) ?? RepoFileContent()
                let encodedData = file.content!
                let decodedData = Data(base64Encoded: encodedData, options: .ignoreUnknownCharacters)!
                
                if fileName.contains(".png") || fileName.contains(".jpg") || fileName.contains(".jpeg") || fileName.contains(".gif") || fileName.contains(".svg") {
                    let image = UIImage(data: decodedData)
                    contentImage.image = image
                    contentImage.contentMode = .scaleAspectFit
                    contentTextView.isHidden = true
                    contentImage.isHidden = false
                } else if let content = String(data: decodedData, encoding: .utf8) {
                    if fileName.contains(".txt") {
                        contentTextView.text = content
                    } else if fileName.contains(".md") {
                        contentTextView.text = content
                    } else {
                        let highlightr = Highlightr()
                        highlightr?.setTheme(to: "paraiso-dark")
                        highlightr?.theme.setCodeFont(RPFont(name: "FiraCode-Medium", size: 12)!)
                        if let highlightedCode = highlightr?.highlight(content) {
                            contentTextView.attributedText = highlightedCode
                        } else {
                            contentTextView.text = "Contenido no disponible"
                            contentTextView.isUserInteractionEnabled = false
                        }
                    }
                } else {
                    contentTextView.text = "Contenido no disponible"
                }
                
            default:
                guard let error = dataModel as? ErrorResponse else { return }
                presentSimpleAlert(title: "Error", message: "\(error.message)")
            }
        default:
            break
        }
    }
}
