//
//  FileResponse.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 12/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

struct RepoFileInfo: Codable {
    let name: String
    let size: Int
    let type: String
}

enum FileType: String {
    case file = "file"
    case dir = "dir"
}
