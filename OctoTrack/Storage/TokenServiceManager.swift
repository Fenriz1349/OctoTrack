//
//  TokenServiceManager.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation

protocol TokenServiceManager {
    func insert(key: String, data: Data) throws
    func retrieve(key: String)  throws -> Data
    func delete(key: String) throws
    func existsInKeychain(key: String) -> Bool
}

final class KeychainService: TokenServiceManager {

    func insert(key: String, data: Data) throws {
        guard !key.isEmpty else {
            throw URLError(.dataNotAllowed)
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw URLError(.cannotCreateFile)
        }
    }

    func retrieve(key: String) throws -> Data {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        guard status == noErr, let data = result as? Data else {
            throw URLError(.fileDoesNotExist)
        }
        return data
    }

    func delete(key: String) throws {
        if existsInKeychain(key: key) {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key as Any
            ] as CFDictionary

            guard SecItemDelete(query) == noErr else {
                throw URLError(.cannotRemoveFile)
            }
        }
    }

    func existsInKeychain(key: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: kCFBooleanTrue as Any
        ] as CFDictionary

        let status = SecItemCopyMatching(query, nil)
        return status == noErr
    }
}
