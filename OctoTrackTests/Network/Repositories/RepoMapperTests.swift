//
//  RepoMapperTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 06/06/2025.
//

import XCTest
@testable import OctoTrack

final class RepoMapperTests: XCTestCase {

    func test_map_badStatusCode() throws {
        // Given
        let response = anyHTTPURLResponse(statusCode: 404)

        // When/Then
        XCTAssertThrowsError(try RepoMapper.map(anyData(), and: response))
    }

    func test_map_success() throws {
        // Given
        let (expectedRepo, repoData) = makeRepositoryResponse()
        let response = anyHTTPURLResponse()

        // When
        let repo = try RepoMapper.map(repoData, and: response)

        // Then
        XCTAssertEqual(repo.id, expectedRepo.id)
        XCTAssertEqual(repo.name, expectedRepo.name)
        XCTAssertEqual(repo.owner.login, expectedRepo.owner.login)
        XCTAssertEqual(repo.priority, .low)
    }

    func test_map_invalidJSON() throws {
        // Given
        let response = anyHTTPURLResponse()
        let invalidData = "invalid".data(using: .utf8)!

        // When/Then
        XCTAssertThrowsError(try RepoMapper.map(invalidData, and: response))
    }
}
