//
//  GistDetailViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 05/03/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

protocol GistDetailViewControllerDelegate: AnyObject {
    func resetTableView()
}

class GistDetailViewController: UIViewController {
    public var gistTitle = ""
    public var gistFiles = ""
    public weak var delegate: GistDetailViewControllerDelegate?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var filesLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var color = UIColor.white
        
        if #available(iOS 13.0, *) {
            color = UIColor.systemBackground
        }
        
        containerView.roundView(bgColor: color)
        
        titleLabel.text = gistTitle
        filesLabel.text = gistFiles
        
        let behindPressGesture = UITapGestureRecognizer(target: self, action: #selector(self.recognizeTap))
        view.addGestureRecognizer(behindPressGesture)
    }
    
    @objc func recognizeTap(_ tapGesture: UITapGestureRecognizer) {
        dismiss(animated: true) {
            self.delegate?.resetTableView()
        }
    }
    
}
