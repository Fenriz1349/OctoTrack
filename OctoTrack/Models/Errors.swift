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
    case networkError(Error)
    case insertUserFail
    case noCurrentUser
    case refreshFailure
}
