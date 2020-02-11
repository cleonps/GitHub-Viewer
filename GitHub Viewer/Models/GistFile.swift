//
//  GistFile.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 11/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

struct GistFile: Codable {
    let filename: String
    let type: String
    let size: Int
}
