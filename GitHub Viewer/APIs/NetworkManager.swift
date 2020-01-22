//
//  NetworkManager.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 18/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit
import Alamofire

protocol NetworkManagerDelegate {
    func response<T: Codable>(dataModel: T, endpoint: Router, code: StatusCodes)
    func unparseableResponse(error message: String, endpoint: Router, code: StatusCodes)
    func connectionFailed(error message: String?, delay: Int?, newTitle: String?)
}

extension NetworkManagerDelegate {
    func connectionFailed(error message: String? = nil, delay: Int? = 0, newTitle: String? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay!), execute: {
            let msg = message ?? "Verifique que cuente con conexión a internet."
            let title = newTitle ?? "Error"
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            (self as! UIViewController).present(alert, animated: true)
        })
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    var authorization = HTTPHeader.authorization(username: "", password: "")
    var delegate: NetworkManagerDelegate?
    
    private init() {}
}

// MARK: API Calls
extension NetworkManager {
    
    func login(email: String, password: String) {
        authorization = HTTPHeader.authorization(username: email, password: password)
        let route = Router.login
        handleRequest(route: route, validModel: UserResponse.self)
    }
    
    func getGists(user: String) {
        let route = Router.getGists(username: user)
        handleRequest(route: route, validModel: [GistResponse].self)
    }
    
}

// MARK: Response handler functions
extension NetworkManager {
    
    func handleRequest<T: Codable>(route: Router, validModel: T.Type) {
        AF.request(route).responseString { (response) in
            switch response.result {
            case .success:
                self.parseResponse(response, validModel: validModel.self, endpoint: route)
            case .failure(let error):
                self.displayErrorResponse(error)
            }
        }
    }
    
    func parseResponse<T: Codable>(_ response: AFDataResponse<String>,validModel: T.Type, endpoint: Router) {
        guard let status = response.response?.statusCode else { return }
        guard let statusCode = StatusCodes(rawValue: status) else { return }
        guard let data = response.data else { return }
        
        do {
            switch statusCode {
            case .success, .accepted, .created, .notFound:
                let user = try JSONDecoder().decode(validModel.self, from: data)
                self.delegate!.response(dataModel: user, endpoint: endpoint, code: statusCode)
            default:
                let error = try JSONDecoder().decode(ErrorResponse.self, from: data)
                self.delegate!.response(dataModel: error, endpoint: endpoint, code: statusCode)
            }
        } catch {
            let errorMessage = response.value ?? "Undefined Error"
            self.delegate!.unparseableResponse(error: errorMessage, endpoint: endpoint, code: statusCode)
        }
    }
    
    func displayErrorResponse(_ error: AFError) {
        let errorMessage = NetworkReachabilityManager()!.isReachable ? error.localizedDescription : nil
        self.delegate?.connectionFailed(error: errorMessage)
    }
}
