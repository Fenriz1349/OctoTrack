//
//  KeyChainService.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation

protocol KeychainServiceProtocol {
    func insert(key: String, data: Data) throws
    func retrieve(key: String)  throws -> Data
    func delete(key: String) throws
}

final class KeychainService: KeychainServiceProtocol {

    func insert(key: String, data: Data) throws {
        guard !key.isEmpty else {
            throw Errors.emptyKey
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        // Supprimez d'abord toute valeur existante pour cette clé
        SecItemDelete(query as CFDictionary)

        // Ajoutez la nouvelle valeur
        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw Errors.insertFailed
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
            throw Errors.retrieveFailed
        }
        print("token storage sucess with key \(key)")
        return data
    }

    func delete(key: String) throws {
        if existsInKeychain(key: key) {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key as Any
            ] as CFDictionary

            guard SecItemDelete(query) == noErr else {
                throw Errors.deleteFailed
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
