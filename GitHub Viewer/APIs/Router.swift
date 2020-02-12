//
//  Router.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 18/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURL = "https://api.github.com/"
    
    case login
    case getGists(username: String)
    case getGistFiles(id: String)
    case getRepos
    
    var path: String {
        switch self {
        case .login:
            return "user"
        case .getGists(let username):
            return "users/\(username)/gists"
        case .getGistFiles(let id):
        return "gists/\(id)"
        case .getRepos:
            return "user/repos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .getGists, .getGistFiles, .getRepos:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login, .getGists, .getGistFiles, .getRepos:
            return HTTPHeaders([
                NetworkManager.shared.authorization,
                .accept("application/vnd.github.v3+json")
            ])
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.headers = headers
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
