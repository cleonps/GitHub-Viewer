//
//  Authorization.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 17/05/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

struct Authorization: Codable {
    let access_token: String
    let scope: String
    let token_type: String
}
