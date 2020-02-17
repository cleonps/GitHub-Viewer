//
//  GistResponse.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 21/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

struct GistResponse: Codable {
    let id: String
    let files: FileList
    let accessLevel: Bool
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id, files, description
        case accessLevel = "public"
    }
    
    struct FileList: Codable {
        let files: [String: GistFile]
        
        struct DetailKey: CodingKey {
            var stringValue: String
            var intValue: Int?
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            init?(intValue: Int) {
                self.stringValue = "\(intValue)";
                self.intValue = intValue
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DetailKey.self)
            
            var files = [String: GistFile]()
            for key in container.allKeys {
                if let fields = try? container.decode(GistFile.self, forKey: key) {
                    files[key.stringValue] = fields
                }
            }
            
            self.files = files
        }
    }
    
}
