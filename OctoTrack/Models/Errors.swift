//
//  Errors.swift
//  OctoTrack
//
//  Created by Julien Cotte on 28/02/2025.
//

import Foundation

enum Errors: Swift.Error {
    #warning("retirer toutes ces erreurs, et throw directement l'erreur native de Swift")
    case invalidResponse
    case missingToken
    case invalidToken
    case tokenExpired
    case emptyKey
    case insertFailed
    case retrieveFailed
    case deleteFailed
    case invalidUUID
    case invalidURL
    case noHTTPURLResponse
    case authenticationFailed
    case missingAuthorizationCode
}
