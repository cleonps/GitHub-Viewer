//
//  GistFile.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 11/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

struct GistFile: Codable {
    var filename: String
    var type: String
    var size: Int
    var content: String?
}
