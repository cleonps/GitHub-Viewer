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
    
    lazy var user = userDefaults.string(forKey: .user)!
    public var repo = ""
    private var isSubdirectory = false
    private var fileList = [RepoFileInfo]()
    private var fileName = ""
    private var path = ""
    private var sentFileName = ""
    private var sentPath = ""
    
    @IBOutlet var repoFilesTableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = fileName != "" ? fileName : repo
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.repoFile.rawValue:
            guard let destinationVC = segue.destination as? RepoFileViewController else { return }
            destinationVC.repo = repo
            destinationVC.path = sentPath
            destinationVC.fileName = sentFileName
        default:
            return
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        if isSubdirectory {
            NetworkManager.shared.getRepoSubContents(user: user, repo: repo, file: path)
        } else {
            NetworkManager.shared.getRepoContents(user: user, repo: repo)
        }
    }
}

extension RepoContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(withName: .gist, for: indexPath) as? GistTableViewCell else {
            return UITableViewCell()
        }
        
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
        
        sentPath = path + "/" + fileList[row].name
        sentFileName = fileList[row].name
        
        if fileList[row].type == FileType.file.rawValue {
            performSegue(withIdentifier: .repoFile)
        } else {
            guard let viewController = instantiateVC(storyboard: .repos, identifier: .reposList, controller: RepoContentsViewController.self) else { return }
            viewController.repo = repo
            viewController.path = sentPath
            viewController.fileName = sentFileName
            viewController.isSubdirectory = true
            self.navigationController?.pushViewController(viewController, animated: true)
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
                fileList = (dataModel as? [RepoFileInfo]) ?? []
                repoFilesTableView.reloadData()
            default:
                guard let error = dataModel as? ErrorResponse else { return }
                presentSimpleAlert(title: "Error", message: "\(error.message)")
            }
        default:
            break
        }
    }
}
