//
//  UserResponse.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 18/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

struct UserData: Codable {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String?
    let html_url: String
    let name: String?
    let blog: String?
    let location: String?
    let email: String?
    let public_repos: Int
    let public_gists: Int
    let followers: Int
    let following: Int
}
