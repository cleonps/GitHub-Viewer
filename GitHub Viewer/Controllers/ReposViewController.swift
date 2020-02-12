//
//  ReposViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 12/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

class ReposViewController: UITableViewController {
    var refresher = UIRefreshControl()
    var repos = [ReposResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.delegate = self
        NetworkManager.shared.getRepos()
        tableView.register(nibName: .gist, cellName: .gist)
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        NetworkManager.shared.getRepos()
    }
}

// UITableViewDelegate, UITableViewDataSource
extension ReposViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(withName: .gist, for: indexPath) as! GistTableViewCell
        let row = indexPath.row
        
        let name = "Repo: \(repos[row].name)."
        let accessLevel = "Privacidad: \(repos[row].isPrivate ? "Privado" : "Público")."
        let description = repos[row].description ?? ""
        let repoDescription = description != "" ? "\nDescripción: \(description)" : ""
        
        cell.fileNameLabel.text = "\(name) \(accessLevel)\(repoDescription)"
        
        return cell
    }
}

extension ReposViewController: NetworkManagerDelegate {
    func response(withError error: String, endpoint: Router) {
        self.refresher.endRefreshing()
        switch endpoint {
        case .getRepos:
            presentSimpleAlert(title: "Error", message: error)
        default:
            break
        }
    }
    
    func response<T: Codable>(dataModel: T, endpoint: Router, code: StatusCodes) {
        self.refresher.endRefreshing()
        switch endpoint {
        case .getRepos:
            switch code {
            case .success, .accepted:
                repos = dataModel as! [ReposResponse]
                tableView.reloadData()
            default:
                let error = dataModel as! ErrorResponse
                presentSimpleAlert(title: "Error", message: "\(error.message)")
            }
        default:
            break
        }
    }
    
    
}
