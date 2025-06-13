//
//  TokenMapper.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation

struct TokenData: Codable {
    let token: String
    let creationDate: Date
}

enum TokenMapper {

    static func decodeToken(from data: Data) throws -> TokenData {
        let decoder = JSONDecoder()
        return try decoder.decode(TokenData.self, from: data)
    }

    static func encodeToken(_ tokenData: TokenData) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(tokenData)
    }

    static func getUUID(from tokenString: String) throws -> UUID {
        guard let uuid = UUID(uuidString: tokenString) else {
            throw URLError(.cannotDecodeRawData)
        }
        return uuid
    }

    static func createTokenData(with token: String) -> TokenData {
            return TokenData(token: token, creationDate: Date())
        }
}
