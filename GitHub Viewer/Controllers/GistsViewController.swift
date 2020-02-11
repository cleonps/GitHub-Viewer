//
//  GistsViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 18/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

class GistsViewController: UIViewController {
    let refresher = UIRefreshControl()
    let userDefaults = UserDefaults.standard
    
    var gists: [GistResponse] = []
    var username = ""
    var idGist = ""
    var gistDescription = ""
    var gistFiles = [GistFile]()
    
    @IBOutlet var gistListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = userDefaults.value(forKey: UserDefaults.Keys.User) else {
            dismiss(animated: true)
            return
        }
        
        username = user as! String
        
        gistListTableView.register(nibName: .gist, cellName: .gist)
        gistListTableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.setAnimationsEnabled(true)
        NetworkManager.shared.delegate = self
        
        if gists.isEmpty {
            NetworkManager.shared.getGists(user: username)
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        NetworkManager.shared.getGists(user: username)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.gistFileList.rawValue:
            let destinationVC = segue.destination as! GistFilesViewController
            destinationVC.idGist = idGist
            destinationVC.gistDescription = gistDescription
            destinationVC.gistFiles = gistFiles
        default:
            return
        }
    }
    
}

extension GistsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(withName: .gist, for: indexPath) as! GistTableViewCell
        let row = indexPath.row
        
        cell.fileNameLabel.text = gists[row].description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.gistListTableView.rowHeight = UITableView.automaticDimension
        self.gistListTableView.estimatedRowHeight = 37.0
        return gistListTableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        idGist = gists[row].id
        gistDescription = gists[row].description
        gistFiles = gists[row].files.files.map { $1 }
        performSegue(withIdentifier: Segues.gistFileList.rawValue, sender: nil)
    }
    
}

extension GistsViewController: NetworkManagerDelegate {
    func response(withError error: String, endpoint: Router) {
        self.refresher.endRefreshing()
        switch endpoint {
        case .getGists:
            presentSimpleAlert(title: "Error", message: error)
        default:
            break
        }
    }
    
    func response<T: Codable>(dataModel: T, endpoint: Router, code: StatusCodes) {
        self.refresher.endRefreshing()
        switch endpoint {
        case .getGists:
            switch code {
            case .success, .accepted:
                gists = dataModel as! [GistResponse]
                gistListTableView.reloadData()
            default:
                let error = dataModel as! ErrorResponse
                presentSimpleAlert(title: "Error", message: "\(error.message)")
            }
        default:
            break
        }
    }
    
}
