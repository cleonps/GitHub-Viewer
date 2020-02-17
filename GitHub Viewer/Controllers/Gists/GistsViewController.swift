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
    
    private var gists: [GistResponse] = []
    private var username = ""
    private var idGist = ""
    
    @IBOutlet var gistListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = userDefaults.value(forKey: .User) else {
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
        
        let description = gists[row].description
        let accessLevel = "\nAcceso: \(gists[row].accessLevel ? "Público" : "Privado")."
        cell.fileNameLabel.text = "\(description)\(accessLevel)"
        
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
        performSegue(withIdentifier: .gistFileList)
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
