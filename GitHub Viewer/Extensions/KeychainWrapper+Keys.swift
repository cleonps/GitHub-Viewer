//
//  KeychainWrapper+Keys.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 05/03/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

extension KeychainWrapper {
    public enum Keys: String, CaseIterable {
        case code
        case token
    }
    
    public func set(_ value: String, forKey key: KeychainWrapper.Keys, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
        set(value, forKey: key.rawValue, withAccessibility: accessibility)
    }
    
    public func string(forKey key: KeychainWrapper.Keys, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> String? {
        return string(forKey: key.rawValue, withAccessibility: accessibility)
    }
}
