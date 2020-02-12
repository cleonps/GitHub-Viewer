//
//  ReposResponse.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 12/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

struct ReposResponse: Codable {
    var id: Int
    var name: String
    var description: String?
    var fork: Bool
    var isPrivate: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case fork
        case isPrivate = "private"
    }
}
