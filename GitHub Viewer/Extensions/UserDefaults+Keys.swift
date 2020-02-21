//
//  UserDefaults+Keys.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 08/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

extension UserDefaults{
    public enum Keys: String, CaseIterable{
        case User = "user"
        case Password = "password"
        case AvatarURL = "avatarURL"
        case Name = "name"
        case Blog = "blog"
        case Location = "location"
        case Email = "email"
        case PublicRepos = "publicRepos"
        case PublicGists = "publicGists"
        case Followers = "followers"
        case Following = "following"
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
