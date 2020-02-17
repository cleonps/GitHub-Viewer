//
//  GistFilesViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 11/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

class GistFilesViewController: UIViewController {
    let refresher = UIRefreshControl()
    
    public var idGist = ""
    private var gistDescription = ""
    private var gistFiles = [GistFile]()
    private var sentContent = ""
    private var sentTitle = ""
    
    @IBOutlet var gistDescriptionLabel: UILabel!
    @IBOutlet var gistFilesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gistFilesTableView.register(nibName: .gist, cellName: .gist)
        gistFilesTableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkManager.shared.delegate = self
        
        if gistFiles.isEmpty {
            NetworkManager.shared.getGistFiles(id: idGist)
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        NetworkManager.shared.getGistFiles(id: idGist)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.gistFile.rawValue:
            let destinationVC = segue.destination as! GistFileContentViewController
            destinationVC.gistTitle = sentTitle
            destinationVC.content = sentContent
        default:
            return
        }
    }
}

extension GistFilesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gistFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(withName: .gist, for: indexPath) as! GistTableViewCell
        let row = indexPath.row
        
        cell.cellImage.image = #imageLiteral(resourceName: "file")
        cell.nameLabel.text = gistFiles[row].filename
        cell.detailLabel.text = "Tamaño: \(gistFiles[row].size) Bytes"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        sentContent = gistFiles[row].content ?? ""
        sentTitle = gistFiles[row].filename
        performSegue(withIdentifier: .gistFile)
    }
    
}

extension GistFilesViewController: NetworkManagerDelegate {
    func response<T:Codable>(dataModel: T, endpoint: Router, code: StatusCodes) {
        self.refresher.endRefreshing()
        switch endpoint {
        case .getGistFiles:
            switch code {
            case .success, .accepted:
                let gistResponse = dataModel as! GistResponse
                gistFiles = gistResponse.files.files.map { $1 }
                gistDescription = gistResponse.description
                
                gistDescriptionLabel.text = "Descripción: \(gistDescription)"
                gistFilesTableView.reloadData()
            default:
                let error = dataModel as! ErrorResponse
                
                gistDescriptionLabel.text = "No se pudieron obtener los datos"
                presentSimpleAlert(title: "Error", message: "\(error.message)")
            }
        default:
            break
        }
    }
    
    func response(withError error: String, endpoint: Router) {
        self.refresher.endRefreshing()
        switch endpoint {
        case .getGistFiles:
            presentSimpleAlert(title: "Error", message: error)
        default:
            break
        }
    }
    
    
}
