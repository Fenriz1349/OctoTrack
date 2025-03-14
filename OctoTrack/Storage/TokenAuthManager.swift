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

    init(keychain: KeychainServiceProtocol = KeychainService()) {
        self.keychain = keychain
    }

    func storeToken(_ token: String) throws {
        let tokenData = TokenMapper.createTokenData(with: token)
        let data = try TokenMapper.encodeToken(tokenData)
        try keychain.insert(key: tokenKey, data: data)
    }

    func retrieveToken() throws -> String {
        let data = try keychain.retrieve(key: tokenKey)
        let tokenData = try TokenMapper.decodeToken(from: data)
        return tokenData.token
    }

    func retrieveTokenData() throws -> TokenData {
        let data = try keychain.retrieve(key: tokenKey)
        return try TokenMapper.decodeToken(from: data)
    }

    func deleteToken() throws {
        try keychain.delete(key: tokenKey)
    }

    func isTokenExpired(expirationDays: Int = 7) -> Bool {
        do {
            let tokenData = try retrieveTokenData()
            let calendar = Calendar.current
            let expirationDate = calendar.date(byAdding: .day, value: expirationDays, to: tokenData.creationDate)!
            return Date() >= expirationDate
        } catch {
            return true
        }
    }

    var isAuthenticated: Bool {
        return keychain.existsInKeychain(key: tokenKey) && !isTokenExpired()
    }
}
