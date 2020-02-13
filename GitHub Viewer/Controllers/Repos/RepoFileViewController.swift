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
    var content = ""
    
    @IBOutlet var contentTextView: UITextView!
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkManager.shared.delegate = self
        if content.isEmpty {
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
                content = dataModel as! String
                contentTextView.text = content
            default:
                let error = dataModel as! ErrorResponse
                presentSimpleAlert(title: "Error", message: "\(error.message)")
            }
        default:
            break
        }
    }
}
