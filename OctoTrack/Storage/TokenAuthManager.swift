//
//  TokenAuthManager.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/03/2025.
//

import Foundation

final class TokenAuthManager {
    private let keychain: KeychainServiceProtocol
    private let tokenKey = "github.access.token"
    private let expirationDelay: Double = 7 * 24 * 60 * 60 // 1 week

    init(keychain: KeychainServiceProtocol = KeychainService()) {
        self.keychain = keychain
    }

    func storeToken(_ token: String) throws {
        let tokenData = TokenMapper.createTokenData(with: token)
        let data = try TokenMapper.encodeToken(tokenData)
        try keychain.insert(key: tokenKey, data: data)
    }

    var getToken: String {
        get throws {
            let tokenData = try getTokenDataFromKeychain()
            return tokenData.token
        }
    }

    func deleteToken() throws {
        try keychain.delete(key: tokenKey)
    }

    var isAuthenticated: Bool {
        return keychain.existsInKeychain(key: tokenKey)
    }

    func isTokenExpired() -> Bool {
        do {
            let tokenData = try getTokenDataFromKeychain()

            let expirationDate = tokenData.creationDate.addingTimeInterval(expirationDelay)
            return Date() > expirationDate
        } catch {
            return true
        }
    }

    func refreshToken() throws {
           let tokenData = try getTokenDataFromKeychain()
           let refreshedTokenData = TokenMapper.createTokenData(with: tokenData.token)
           let data = try TokenMapper.encodeToken(refreshedTokenData)
           try keychain.insert(key: tokenKey, data: data)
        print("token refresh")
       }

    private func getTokenDataFromKeychain() throws -> TokenData {
        do {
            let tokenData = try keychain.retrieve(key: tokenKey)
            return try TokenMapper.decodeToken(from: tokenData)
        } catch {
            throw Errors.invalidToken
        }
    }
}
