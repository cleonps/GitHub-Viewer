//
//  GistFileContentViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 11/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

class GistFileContentViewController: UIViewController {
    public var content = ""
    public var gistTitle = ""
    
    @IBOutlet var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = gistTitle
        contentTextView.text = content
    }
}
