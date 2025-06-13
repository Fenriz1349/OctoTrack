//
//  TokenAuthManagerTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
@testable import OctoTrack

final class TokenAuthManagerTests: XCTestCase {
    
    func test_storeToken_callsKeychainInsert() throws {
        // Given
        let keychain = KeychainServiceSpy()
        let sut = TokenAuthManager(keychain: keychain)
        
        // When
        try sut.storeToken(makeAccessToken())
        
        // Then
        XCTAssertEqual(keychain.insertCallCount, 1)
        XCTAssertTrue(keychain.existsInKeychain(key: "github.access.token"))
    }

    func test_deleteToken_callsKeychainDelete() throws {
        // Given
        let keychain = KeychainServiceSpy()
        let sut = TokenAuthManager(keychain: keychain)
        try sut.storeToken(makeAccessToken())
        
        // When
        try sut.deleteToken()
        
        // Then
        XCTAssertEqual(keychain.deleteCallCount, 1)
        XCTAssertFalse(keychain.existsInKeychain(key: "github.access.token"))
    }
}
