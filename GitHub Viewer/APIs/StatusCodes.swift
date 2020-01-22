//
//  StatusCodes.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 18/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import Foundation

enum StatusCodes: Int {
    case internalServerError = 500
    case notFound = 404
    case forbidden = 403
    case unauthorized = 401
    case badRequest = 400
    case multipleChoices = 300
    case accepted = 202
    case created = 201
    case success = 200
}
