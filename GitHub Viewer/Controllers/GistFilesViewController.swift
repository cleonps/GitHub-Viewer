//
//  GistFilesViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 11/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

class GistFilesViewController: UIViewController {
    var idGist = ""
    var gistDescription = ""
    var gistFiles = [GistFile]()
    
    @IBOutlet var gistDescriptionLabel: UILabel!
    @IBOutlet var gistFilesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gistDescriptionLabel.text = "Descripción: \(gistDescription)"
        gistFilesTableView.delegate = self
        gistFilesTableView.register(nibName: .gist, cellName: .gist)
    }
}

extension GistFilesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gistFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(withName: .gist, for: indexPath) as! GistTableViewCell
        let row = indexPath.row
        
        cell.fileNameLabel.text = gistFiles[row].filename
        
        return cell
    }
    
}

