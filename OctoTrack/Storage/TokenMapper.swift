//
//  TokenMapper.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation

enum TokenMapper {
    
    static func getTokenString(from key: String) throws -> String {
        let keychain = KeychainService()
        guard !key.isEmpty else {
            throw Errors.emptyKey
        }

        guard let  data = try? keychain.retrieve(key: key),
              let tokenString = String(data: data, encoding: .utf8) else {
            throw Errors.retrieveFailed
        }
        return tokenString
    }
    
    static func getToken(from key: String) throws -> UUID {
        guard let tokenString = try? getTokenString(from: key),
            let token = UUID(uuidString: tokenString) else {
            throw Errors.invalidUUID
        }
        return token
    }
}
