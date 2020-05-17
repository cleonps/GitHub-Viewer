//
//  Secrets.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 17/05/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

enum Secrets {
    
    enum GitHub {
        static let clientId = Secrets.environmentVariable(named: "GITHUB_CLIENT_ID")
        static let clientSecret = Secrets.environmentVariable(named: "GITHUB_CLIENT_SECRET")
    }
    
    fileprivate static func environmentVariable(named: String) -> String? {
        let processInfo = ProcessInfo.processInfo

        guard let value = processInfo.environment[named] else {
            print("‼️ Missing Environment Variable: '\(named)'")
            return nil
        }

        return value
    }

}
