//
//  GitHubAuthenticatorTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 09/05/2025.
//

import XCTest
import AuthenticationServices
@testable import OctoTrack

/// We only test application logic, so we avoid testing ASWebAuthentication
final class GitHubAuthenticatorTests: XCTestCase {

    // MARK: - AuthenticationState Tests

    func test_authenticationState_returnsUnauthenticatedWhenNoToken() {
        // Given
        let keychainMock = KeychainServiceSpy()
        let tokenManager = TokenAuthManager(keychain: keychainMock)
        let sut = GitHubAuthenticator(client: HTTPClientStub(result: .success((Data(), anyHTTPURLResponse()))),
                                      tokenAuthManager: tokenManager)

        // When
        let state = sut.authenticationState

        // Then
        XCTAssertEqual(state, .unauthenticated)
    }

    func test_authenticationState_returnsAuthenticatedWithValidToken() throws {
        // Given
        let keychainMock = KeychainServiceSpy()
        let tokenManager = TokenAuthManager(keychain: keychainMock)
        let sut = GitHubAuthenticator(client: HTTPClientStub(result: .success((Data(), anyHTTPURLResponse()))),
                                      tokenAuthManager: tokenManager)

        let token = makeAccessToken()
        try tokenManager.storeToken(token)

        // When
        let state = sut.authenticationState

        // Then
        XCTAssertEqual(state, .authenticated)
    }

    func test_authenticationState_returnsExpiredWithExpiredToken() throws {
        // Given
        let keychainMock = KeychainServiceSpy()
        let tokenManager = TokenAuthManager(keychain: keychainMock)
        let expiredTokenData = try TokenMapper
            .encodeToken(TokenData(token: makeAccessToken(),
                                   creationDate: Date().addingTimeInterval(-8 * 24 * 60 * 60)))
        try keychainMock.insert(key: "github.access.token", data: expiredTokenData)

        let sut = GitHubAuthenticator(client: HTTPClientStub(result: .success((Data(), anyHTTPURLResponse()))),
                                      tokenAuthManager: tokenManager)

        // When
        let state = sut.authenticationState

        // Then
        XCTAssertEqual(state, .expired)
    }

    func test_authenticate_returnsImmediatelyWhenAlreadyAuthenticated() async throws {
        // Given
        let (sut, client, tokenManager, _) = makeSUTAuthenticator()
        try tokenManager.storeToken(makeAccessToken())
        
        // When
        try await sut.authenticate()
        
        // Then
        XCTAssertEqual(client.requests.count, 0) // Pas de requête
        XCTAssertEqual(sut.authenticationState, .authenticated)
    }

    // MARK: - Sign Out Tests

    func test_signOut_deletesToken() throws {
        // Given
        let keychainMock = KeychainServiceSpy()
        let tokenManager = TokenAuthManager(keychain: keychainMock)
        let sut = GitHubAuthenticator(client: HTTPClientStub(result: .success((Data(), anyHTTPURLResponse()))),
                                      tokenAuthManager: tokenManager)

        let token = makeAccessToken()
        try tokenManager.storeToken(token)

        XCTAssertTrue(keychainMock.existsInKeychain(key: "github.access.token"))

        // When
        try sut.signOut()

        // Then
        XCTAssertFalse(keychainMock.existsInKeychain(key: "github.access.token"))
        XCTAssertEqual(sut.authenticationState, .unauthenticated)
        XCTAssertEqual(keychainMock.deleteCallCount, 1)
    }

    // MARK: - Refresh Token Tests

    func test_refreshToken_updatesTokenCreationDate() throws {
        // Given
        let keychainMock = KeychainServiceSpy()
        let tokenManager = TokenAuthManager(keychain: keychainMock)
        let sut = GitHubAuthenticator(client: HTTPClientStub(result: .success((Data(), anyHTTPURLResponse()))),
                                      tokenAuthManager: tokenManager)

        let oldDate = Date().addingTimeInterval(-3 * 24 * 60 * 60) // 3 jours dans le passé
        let tokenData = TokenData(token: makeAccessToken(), creationDate: oldDate)
        let encodedData = try TokenMapper.encodeToken(tokenData)
        try keychainMock.insert(key: "github.access.token", data: encodedData)

        // When
        try sut.refreshToken()

        // Then
        let retrievedData = try keychainMock.retrieve(key: "github.access.token")
        let decodedToken = try TokenMapper.decodeToken(from: retrievedData)

        XCTAssertGreaterThan(decodedToken.creationDate, oldDate)
        XCTAssertEqual(keychainMock.insertCallCount, 2) // 1 pour setup initial + 1 pour refresh
    }

    // MARK: - Is Token Valid Tests

    func test_isTokenValid_returnsTrueForValidToken() async {
        // Given
        let client = HTTPClientStub(result: .success((anyData(), anyHTTPURLResponse(statusCode: 200))))
        let keychainMock = KeychainServiceSpy()
        let tokenManager = TokenAuthManager(keychain: keychainMock)
        let sut = GitHubAuthenticator(client: client, tokenAuthManager: tokenManager)

        try? tokenManager.storeToken(makeAccessToken())

        // When
        let isValid = await sut.isTokenValid()

        // Then
        XCTAssertTrue(isValid)
        XCTAssertEqual(client.requests.count, 1)
        XCTAssertEqual(client.requests.first?.url?.path, "/user")
    }

    func test_isTokenValid_returnsFalseForInvalidToken() async {
        // Given
        let client = HTTPClientStub(result: .success((anyData(), anyHTTPURLResponse(statusCode: 401))))
        let keychainMock = KeychainServiceSpy()
        let tokenManager = TokenAuthManager(keychain: keychainMock)
        let sut = GitHubAuthenticator(client: client, tokenAuthManager: tokenManager)

        try? tokenManager.storeToken(makeAccessToken())

        // When
        let isValid = await sut.isTokenValid()

        // Then
        XCTAssertFalse(isValid)
    }

    func test_isTokenValid_returnsFalseWhenTokenRetrievalFails() async {
        // Given
        let client = HTTPClientStub(result: .success((anyData(), anyHTTPURLResponse(statusCode: 200))))
        let keychainMock = KeychainServiceSpy() // Sans token stocké
        let tokenManager = TokenAuthManager(keychain: keychainMock)
        let sut = GitHubAuthenticator(client: client, tokenAuthManager: tokenManager)

        // When
        let isValid = await sut.isTokenValid()

        // Then
        XCTAssertFalse(isValid)
        XCTAssertEqual(client.requests.count, 0) // Aucune requête ne devrait être faite
    }

    func test_isTokenValid_returnsFalseWhenHTTPRequestFails() async {
        // Given
        let expectedError = anyNSError()
        let client = HTTPClientStub(result: .failure(expectedError))
        let keychainMock = KeychainServiceSpy()
        let tokenManager = TokenAuthManager(keychain: keychainMock)
        let sut = GitHubAuthenticator(client: client, tokenAuthManager: tokenManager)

        try? tokenManager.storeToken(makeAccessToken())

        // When
        let isValid = await sut.isTokenValid()

        // Then
        XCTAssertFalse(isValid)
    }

    // MARK: - Retrieve Token Tests

    func test_retrieveToken_returnsTokenWhenNotExpired() async throws {
        // Given
        let expectedToken = makeAccessToken()
        let (sut, _, tokenManager, _) = makeSUTAuthenticator()
        try tokenManager.storeToken(expectedToken) // Token récent, pas expiré
        
        // When
        let token = try await sut.retrieveToken()
        
        // Then
        XCTAssertEqual(token, expectedToken)
    }

    func test_retrieveToken_returnsTokenWhenAuthenticated() async throws {
        // Given
        let expectedToken = makeAccessToken()
        let keychainMock = KeychainServiceSpy()
        let tokenManager = TokenAuthManager(keychain: keychainMock)
        try tokenManager.storeToken(expectedToken)

        let client = HTTPClientStub(result: .success((anyData(), anyHTTPURLResponse())))
        let sut = GitHubAuthenticator(client: client, tokenAuthManager: tokenManager)

        // When
        let token = try await sut.retrieveToken()

        // Then
        XCTAssertEqual(token, expectedToken)
    }
}
