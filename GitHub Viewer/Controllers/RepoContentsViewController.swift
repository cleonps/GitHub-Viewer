//
//  RepoContentsViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 12/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

class RepoContentsViewController: UIViewController {
    let refresher = UIRefreshControl()
    let userDefaults = UserDefaults.standard
    
    lazy var user = userDefaults.string(forKey: UserDefaults.Keys.User)!
    var repo = ""
    var fileList = [FileReponse]()
    var fileName = ""
    
    @IBOutlet var repoFilesTableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.delegate = self
        repoFilesTableView.register(nibName: .gist, cellName: .gist)
        repoFilesTableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        NetworkManager.shared.getRepoContents(user: user, repo: repo)
        titleLabel.viewStyle()
        titleLabel.text = repo
    }
    
    @objc private func refreshData(_ sender: Any) {
        NetworkManager.shared.getRepoContents(user: user, repo: repo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.repoFile.rawValue:
            let destinationVC = segue.destination as! RepoFileViewController
            destinationVC.repo = repo
            destinationVC.fileName = fileName
        default:
            return
        }
    }
}

extension RepoContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(withName: .gist, for: indexPath) as! GistTableViewCell
        let row = indexPath.row
        let name = "\(fileList[row].name)\n"
        var description = "\tTamaño: \(fileList[row].size) Bytes"
        if fileList[row].type == FileType.dir.rawValue {
            description = "\tDirectorio de archivos"
        }
        
        cell.fileNameLabel.text = "\(name)\(description)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if fileList[row].type == FileType.file.rawValue {
            fileName = fileList[row].name
            performSegue(withIdentifier: Segues.repoFile.rawValue, sender: nil)
        }
    }
}

extension RepoContentsViewController: NetworkManagerDelegate {
    func response(withError error: String, endpoint: Router) {
        self.refresher.endRefreshing()
        switch endpoint {
        case .getRepoContents:
            presentSimpleAlert(title: "Error", message: error)
        default:
            break
        }
    }
    
    func response<T: Codable>(dataModel: T, endpoint: Router, code: StatusCodes) {
        self.refresher.endRefreshing()
        switch endpoint {
        case .getRepoContents:
            switch code {
            case .success, .accepted:
                fileList = dataModel as! [FileReponse]
                repoFilesTableView.reloadData()
            default:
                let error = dataModel as! ErrorResponse
                presentSimpleAlert(title: "Error", message: "\(error.message)")
            }
        default:
            break
        }
    }
}
