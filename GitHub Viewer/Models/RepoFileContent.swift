//
//  RepoFileContent.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 13/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

struct RepoFileContent: Codable {
    var name: String
    var content: String?
    
    init() {
        name = ""
    }
}
