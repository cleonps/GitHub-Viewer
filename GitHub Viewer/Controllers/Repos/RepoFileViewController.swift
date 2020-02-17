//
//  RepoFileViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 12/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

class RepoFileViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    lazy var user = userDefaults.string(forKey: UserDefaults.Keys.User)!
    var repo = ""
    var fileName = ""
    var file = RepoFileContent()
    
    @IBOutlet var contentTextView: UITextView!
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.title = fileName
        NetworkManager.shared.delegate = self
        if file.content == nil {
            NetworkManager.shared.getRepoFileContent(user: user, repo: repo, file: fileName)
        }
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
                file = dataModel as! RepoFileContent
                let encodedData = file.content!
                let decodedData = Data(base64Encoded: encodedData, options: .ignoreUnknownCharacters)!
                let decodedString = String(data: decodedData, encoding: .utf8)
                contentTextView.text = decodedString
            default:
                let error = dataModel as! ErrorResponse
                presentSimpleAlert(title: "Error", message: "\(error.message)")
            }
        default:
            break
        }
    }
}
