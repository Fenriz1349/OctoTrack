//
//  TokenMapper.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation

enum TokenMapper {
    
    enum Error: Swift.Error {
        case emptyKey
        case retrieveFailed
        case invalidUUID
    }
    
    static func getTokenString(from key: String) throws -> String {
        let keychain = KeychainStore()
        guard !key.isEmpty else {
            throw Error.emptyKey
        }

        guard let  data = try? keychain.retrieve(key: key),
              let tokenString = String(data: data, encoding: .utf8) else {
            throw Error.retrieveFailed
        }
        return tokenString
    }
    
    static func getToken(from key: String) throws -> UUID {
        guard let tokenString = try? getTokenString(from: key),
            let token = UUID(uuidString: tokenString) else {
            throw Error.invalidUUID
        }
        return token
    }
}
