//
//  String+URLEncoder.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 17/05/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

extension String {
    var urlEncoded: String {
        let customAllowedSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-._~")
        return self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
    }
}
