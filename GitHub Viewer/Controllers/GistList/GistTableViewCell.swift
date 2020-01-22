//
//  GistTableViewCell.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 21/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

class GistTableViewCell: UITableViewCell {
    
    @IBOutlet var fileNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
