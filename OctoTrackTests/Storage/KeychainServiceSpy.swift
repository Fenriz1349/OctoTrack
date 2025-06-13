//
//  KeychainServiceMock.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 09/05/2025.
//

import Foundation
@testable import OctoTrack

class KeychainServiceSpy: TokenServiceManager {
    var data: [String: Data] = [:]
    var insertCallCount = 0
    var retrieveCallCount = 0
    var deleteCallCount = 0

    func insert(key: String, data: Data) throws {
        insertCallCount += 1
        self.data[key] = data
    }

    func retrieve(key: String) throws -> Data {
        retrieveCallCount += 1
        if let data = self.data[key] {
            return data
        }
        throw URLError(.fileDoesNotExist)
    }

    func delete(key: String) throws {
        deleteCallCount += 1
        if existsInKeychain(key: key) {
            self.data.removeValue(forKey: key)
        } else {
            throw URLError(.fileDoesNotExist)
        }
    }

    func existsInKeychain(key: String) -> Bool {
        return self.data[key] != nil
    }
}
