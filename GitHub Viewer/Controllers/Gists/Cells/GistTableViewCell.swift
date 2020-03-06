//
//  GistTableViewCell.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 21/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

class GistTableViewCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var secondDetailLabel: UILabel!
    @IBOutlet var backgroundCellView: UIView!
    @IBOutlet var padlockImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundCellView.roundView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
