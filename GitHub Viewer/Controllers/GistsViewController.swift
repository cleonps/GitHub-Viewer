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
        NetworkManager.shared.delegate = self
        
        if gists.isEmpty {
            NetworkManager.shared.getGists(user: username)
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        NetworkManager.shared.getGists(user: username)
    }
    
}

extension GistsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return gists.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists[section].files.files.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return gists[section].description
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gistListTableView.dequeReusableCell(withName: .gist, for: indexPath) as! GistTableViewCell
        
        let section = indexPath.section
        let row = indexPath.row
        let key = Array(gists[section].files.files.keys)[row]
        
        cell.textLabel?.text = gists[section].files.files[key]?.filename
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.gistListTableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = 44.0
        return gistListTableView.rowHeight
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
