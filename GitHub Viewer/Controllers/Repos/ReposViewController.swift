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
    var repo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(nibName: .gist, cellName: .gist)
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkManager.shared.delegate = self
        
        if repos.isEmpty {
            NetworkManager.shared.getRepoList()
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        NetworkManager.shared.getRepoList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.repoContents.rawValue:
            let destinationVC = segue.destination as! RepoContentsViewController
            destinationVC.repo = repo
            
        default:
            return
        }
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
        let accessLevel = "\nAcceso: \(repos[row].isPrivate ? "Privado" : "Público")."
        let description = repos[row].description ?? ""
        let repoDescription = description != "" ? "\nDescripción: \(description)" : ""
        
        cell.fileNameLabel.text = "\(name) \(accessLevel)\(repoDescription)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        repo = repos[row].name
        performSegue(withIdentifier: Segues.repoContents.rawValue, sender: nil)
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
