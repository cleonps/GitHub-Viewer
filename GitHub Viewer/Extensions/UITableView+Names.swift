//
//  UITableView+Names.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 21/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit

extension UITableView {
    
    public enum CellNames: String {
        case gist = "GistCell"
    }
    
    public enum NibNames: String {
        case gist = "GistTableViewCell"
    }
    
    public func dequeReusableCell(withName name: CellNames, for indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: name.rawValue, for: indexPath) as UITableViewCell
    }
    
    public func register(nibName: NibNames, cellName: CellNames) {
        self.register(UINib(nibName: nibName.rawValue, bundle: nil), forCellReuseIdentifier: cellName.rawValue)
    }
    
}
