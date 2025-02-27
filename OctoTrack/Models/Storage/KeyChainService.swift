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

final class KeychainStore: KeychainServiceProtocol {
    
    enum Error: Swift.Error {
        case emptyKey
        case insertFailed
        case retrieveFailed
        case deleteFailed
    }
    
    func insert(key: String, data: Data) throws {
        guard key.isEmpty else {
            throw Error.emptyKey
        }
        guard let tokenString = String(data: data, encoding: .utf8),
              UUID(uuidString: tokenString) != nil else {
            throw Error.insertFailed
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
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
            throw Error.retrieveFailed
        }
        
        return data
    }
    
    func delete(key: String) throws {
        //        if existsInKeychain(key: key) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as Any
        ] as CFDictionary
        
        guard SecItemDelete(query) == noErr else {
            throw Error.deleteFailed
        }
        //        }
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
