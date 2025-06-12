//
//  GitHubAuthenticationMapperTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 09/05/2025.
//

import XCTest
@testable import OctoTrack

final class GitHubAuthenticationMapperTests: XCTestCase {

    func test_map_failsOnNon200StatusCode() throws {
        // Given
        let response = anyHTTPURLResponse(statusCode: 400)
        let data = anyData()

        // When/Then
        XCTAssertThrowsError(try GitHubAuthenticationMapper.map(data, and: response)) { error in
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
        }
    }

    func test_map_extractsTokenFromJSON() throws {
        // Given
        let response = anyHTTPURLResponse()
        let expectedToken = makeAccessToken()
        let (json, data) = makeTokenResponse()

        // When
        let token = try GitHubAuthenticationMapper.map(data, and: response)

        // Then
        XCTAssertEqual(token, expectedToken)
    }

    func test_map_extractsTokenFromFormEncodedResponse() throws {
        // Given
        let response = anyHTTPURLResponse()
        let expectedToken = makeAccessToken()
        let formEncoded = "access_token=\(expectedToken)&token_type=bearer&scope=repo%20user"
        let data = formEncoded.data(using: .utf8)!

        // When
        let token = try GitHubAuthenticationMapper.map(data, and: response)

        // Then
        XCTAssertEqual(token, expectedToken)
    }

    func test_map_throwsErrorOnMissingToken() throws {
        // Given
        let response = anyHTTPURLResponse()
        let jsonWithoutToken = ["scope": "repo,user", "token_type": "bearer"]
        let data = try JSONSerialization.data(withJSONObject: jsonWithoutToken)

        // When/Then
        XCTAssertThrowsError(try GitHubAuthenticationMapper.map(data, and: response)) { error in
            XCTAssertEqual(error as? URLError, URLError(.userAuthenticationRequired))
        }
    }

    func test_map_throwsErrorOnInvalidData() throws {
        // Given
        let response = anyHTTPURLResponse()
        let invalidData = "invalid data format".data(using: .utf8)!

        // When/Then
        XCTAssertThrowsError(try GitHubAuthenticationMapper.map(invalidData, and: response)) { error in
            XCTAssertEqual(error as? URLError, URLError(.userAuthenticationRequired))
        }
    }
    
    func test_authenticate_returnsImmediatelyWhenAlreadyAuthenticated() async throws {
        // Given
        let (sut, client, tokenManager, _) = makeSUTAuthenticator()
        try tokenManager.storeToken(makeAccessToken())
        
        // When
        try await sut.authenticate()
        
        // Then
        XCTAssertEqual(client.requests.count, 0)
        XCTAssertEqual(sut.authenticationState, .authenticated)
    }

    func test_refreshToken_updatesTokenCreationDate() throws {
        // Given
        let (sut, _, _, keychain) = makeSUTAuthenticator()
        let expiredTokenData = try makeExpiredTokenData()
        try keychain.insert(key: "github.access.token", data: expiredTokenData)
        
        // When
        try sut.refreshToken()
        
        // Then
        let retrievedData = try keychain.retrieve(key: "github.access.token")
        let decodedToken = try TokenMapper.decodeToken(from: retrievedData)
        XCTAssertGreaterThan(decodedToken.creationDate, Date().addingTimeInterval(-60))
    }
}
