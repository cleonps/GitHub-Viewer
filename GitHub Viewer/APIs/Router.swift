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
    
    case getToken(client: String, secret: String, code: String)
    case login
    case getGists(username: String)
    case getGistFiles(gistId: String)
    case getRepos
    case getRepoContents(username: String, repo: String)
    case getRepoFileContent(username: String, repo: String, file: String)
    case getRepoMDFileContent(username: String, repo: String, file: String)
    
    var path: String {
        switch self {
        case .getToken(let client, let secret, let code):
            return "https://github.com/login/oauth/access_token?client_id=\(client)&client_secret=\(secret)&code=\(code)"
        case .login:
            return "user"
        case .getGists(let username):
            return "users/\(username)/gists"
        case .getGistFiles(let gistId):
        return "gists/\(gistId)"
        case .getRepos:
            return "user/repos"
        case .getRepoContents(let username, let repo):
            return "repos/\(username)/\(repo)/contents"
        case .getRepoFileContent(let username, let repo, let file):
            return "repos/\(username)/\(repo)/contents/\(file)"
        case .getRepoMDFileContent(let username, let repo, let file):
            return "repos/\(username)/\(repo)/contents/\(file)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .getGists, .getGistFiles, .getRepos, .getRepoContents, .getRepoFileContent, .getRepoMDFileContent:
            return .get
        case .getToken:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getRepoMDFileContent:
            return HTTPHeaders([
                NetworkManager.shared.authorization,
                .accept("application/vnd.github.v3.html+json")
            ])
        case .login, .getGists, .getGistFiles, .getRepos, .getRepoContents, .getRepoFileContent:
            return HTTPHeaders([
                NetworkManager.shared.authorization,
                .accept("application/vnd.github.v3+json")
            ])
        case .getToken:
            return HTTPHeaders([
                .accept("application/json")
            ])
        }
        
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURL.asURL()
        var urlRequest = path.contains("http") ? URLRequest(url: URL(string: path)!) : URLRequest(url: url.appendingPathComponent(path))
        urlRequest.headers = headers
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
