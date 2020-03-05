//
//  UserDefaults+Keys.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 08/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

extension UserDefaults {
    public enum Keys: String, CaseIterable {
        case user
        case avatarURL
        case name
        case blog
        case location
        case email
        case publicRepos
        case publicGists
        case followers
        case following
    }
    
    public func setValue(_ value: Any?, forKey key: Keys) {
        setValue(value, forKey: key.rawValue)
    }
    
    public func value(forKey key: Keys) -> Any? {
        return value(forKey: key.rawValue)
    }
    
    public func string(forKey key: Keys) -> String? {
        return string(forKey: key.rawValue)
    }
    
    public func removeObject(forKey key: Keys) {
        removeObject(forKey: key.rawValue)
    }
    
    /// Removes all objects created on User Defaults
    public func removeAll() {
        for key in Keys.allCases {
            removeObject(forKey: key)
        }
    }
}
