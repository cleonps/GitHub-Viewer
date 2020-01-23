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
    var gists: [GistResponse] = []
    var username = ""
    var isLoginDismissed = false
    
    @IBOutlet var gistListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gistListTableView.register(nibName: .gist, cellName: .gist)
        gistListTableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refresData(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isLoginDismissed {
            tabBarController!.view.isHidden = false
            if gists.isEmpty {
                callAPI()
            }
        } else {
            let vc = instantiateVC(storyboard: .login, identifier: .login, controller:  MainViewController.self, presentation: .fullScreen)
            vc.delegate = self
            present(vc, animated: false) {
                self.tabBarController!.view.isHidden = false
            }
        }
    }
    
    @objc private func refresData(_ sender: Any) {
        callAPI()
    }
    
    public func callAPI() {
        NetworkManager.shared.delegate = self
        NetworkManager.shared.getGists(user: self.username)
    }
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

extension GistsViewController: LoginDelegate {
    func updateUsername(_ username: String) {
        self.isLoginDismissed = true
        self.username = username
        self.callAPI()
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
