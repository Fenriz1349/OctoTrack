//
//  PullRequestMapperTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
@testable import OctoTrack

final class PullRequestMapperTests: XCTestCase {

    func test_map_badStatusCode() throws {
        // Given
        let response = anyHTTPURLResponse(statusCode: 404)

        // When/Then
        XCTAssertThrowsError(try PullRequestMapper.map(anyData(), and: response))
    }

    func test_map_success() throws {
        // Given
        let (expectedPR, prData) = makePullRequestResponse()
        let response = anyHTTPURLResponse()

        // When
        let pullRequest = try PullRequestMapper.map(prData, and: response)

        // Then
        XCTAssertEqual(pullRequest.id, expectedPR.id)
        XCTAssertEqual(pullRequest.title, expectedPR.title)
        XCTAssertEqual(pullRequest.number, expectedPR.number)
        XCTAssertEqual(pullRequest.isDraft, expectedPR.isDraft)
    }

    func test_map_invalidJSON() throws {
        // Given
        let response = anyHTTPURLResponse()
        let invalidData = "invalid".data(using: .utf8)!

        // When/Then
        XCTAssertThrowsError(try PullRequestMapper.map(invalidData, and: response))
    }

    func test_mapList_badStatusCode() throws {
        // Given
        let response = anyHTTPURLResponse(statusCode: 404)

        // When/Then
        XCTAssertThrowsError(try PullRequestMapper.mapList(anyData(), and: response))
    }

    func test_mapList_success() throws {
        // Given
        let (expectedPRs, prData) = makePullRequestListResponse()
        let response = anyHTTPURLResponse()

        // When
        let pullRequests = try PullRequestMapper.mapList(prData, and: response)

        // Then
        XCTAssertEqual(pullRequests.count, expectedPRs.count)
        XCTAssertEqual(pullRequests.first?.id, expectedPRs.first?.id)
        XCTAssertEqual(pullRequests.first?.title, expectedPRs.first?.title)
    }

    func test_mapList_invalidJSON() throws {
        // Given
        let response = anyHTTPURLResponse()
        let invalidData = "invalid".data(using: .utf8)!

        // When/Then
        XCTAssertThrowsError(try PullRequestMapper.mapList(invalidData, and: response))
    }
}
