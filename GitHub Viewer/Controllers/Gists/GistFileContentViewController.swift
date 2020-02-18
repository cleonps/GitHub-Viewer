//
//  GistFileContentViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 11/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit
import Highlightr

class GistFileContentViewController: UIViewController {
    public var content = ""
    public var gistTitle = ""
    
    @IBOutlet var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let highlightr = Highlightr()
        highlightr?.setTheme(to: "paraiso-dark")
        let highlightedCode = highlightr?.highlight(content)
        
        self.navigationItem.title = gistTitle
        contentTextView.attributedText = highlightedCode
//        contentTextView.text = content
    }
}
