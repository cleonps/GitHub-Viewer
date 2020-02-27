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
    
    lazy var user = userDefaults.string(forKey: .User)!
    var repo = ""
    var isSubdirectory = false
    var fileList = [RepoFileInfo]()
    var fileName = ""
    var path = ""
    
    @IBOutlet var repoFilesTableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoFilesTableView.register(nibName: .gist, cellName: .gist)
        repoFilesTableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        titleLabel.roundView()
        titleLabel.text = repo
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkManager.shared.delegate = self
        if fileList.isEmpty {
            if isSubdirectory {
                    NetworkManager.shared.getRepoSubContents(user: user, repo: repo, file: path)
            } else {
                    NetworkManager.shared.getRepoContents(user: user, repo: repo)
            }
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        if isSubdirectory {
            NetworkManager.shared.getRepoSubContents(user: user, repo: repo, file: path)
        } else {
            NetworkManager.shared.getRepoContents(user: user, repo: repo)
        }
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
        
        let image = fileList[row].type == FileType.dir.rawValue ? #imageLiteral(resourceName: "folder") : #imageLiteral(resourceName: "file")
        let name = "\(fileList[row].name)"
        var description = "Tamaño: \(fileList[row].size) Bytes"
        if fileList[row].type == FileType.dir.rawValue {
            description = "Directorio de archivos"
        }
        
        cell.cellImage.image = image.withRenderingMode(.alwaysTemplate)
        cell.nameLabel.text = name
        cell.detailLabel.text = description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if fileList[row].type == FileType.file.rawValue {
            if isSubdirectory {
                fileName = path + "/" + fileList[row].name
            } else {
                fileName = fileList[row].name
            }
            performSegue(withIdentifier: .repoFile)
        } else {
            let vc = instantiateVC(storyboard: .repos, identifier: .reposList, controller: RepoContentsViewController.self)
            vc.repo = repo
            vc.path = path + "/" + fileList[row].name
            vc.isSubdirectory = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension RepoContentsViewController: NetworkManagerDelegate {
    func response(withError error: String, endpoint: Router) {
        self.refresher.endRefreshing()
        switch endpoint {
        case .getRepoContents, .getRepoFileContent:
            presentSimpleAlert(title: "Error", message: error)
        default:
            break
        }
    }
    
    func response<T: Codable>(dataModel: T, endpoint: Router, code: StatusCodes) {
        self.refresher.endRefreshing()
        switch endpoint {
        case .getRepoContents, .getRepoFileContent:
            switch code {
            case .success, .accepted:
                fileList = dataModel as! [RepoFileInfo]
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
