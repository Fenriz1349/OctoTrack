//
//  Errors.swift
//  OctoTrack
//
//  Created by Julien Cotte on 28/02/2025.
//

import Foundation

enum Errors: Swift.Error {
    case invalidResponse
    case missingToken
    case emptyKey
    case insertFailed
    case retrieveFailed
    case deleteFailed
    case invalidUUID
    case invalidURL
    case noHTTPURLResponse
    case authenticationCancelled
    case authenticationFailed
    case missingAuthorizationCode
    case tokenExchangeFailed
    case noStoredToken
    case networkError(Error)
    case notFound
}
