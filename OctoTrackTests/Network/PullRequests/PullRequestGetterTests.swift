//
//  PullRequestGetterTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
@testable import OctoTrack

final class PullRequestGetterTests: XCTestCase {

    func test_allPullRequestsGetter_success() async throws {
        // Given
        let (expectedPRs, prData) = makePullRequestListResponse()
        let client = HTTPClientStub(result: .success((prData, anyHTTPURLResponse())))
        let sut = PullRequestGetter(client: client)

        // When
        let pullRequests = try await sut.allPullRequestsGetter(from: anyURLRequest())

        // Then
        XCTAssertEqual(pullRequests.count, expectedPRs.count)
        XCTAssertEqual(pullRequests.first?.id, expectedPRs.first?.id)
        XCTAssertEqual(pullRequests.first?.title, expectedPRs.first?.title)
        XCTAssertEqual(client.requests.count, 1)
    }

    func test_allPullRequestsGetter_failure() async {
        // Given
        let client = HTTPClientStub(result: .failure(anyNSError()))
        let sut = PullRequestGetter(client: client)

        // When/Then
        do {
            _ = try await sut.allPullRequestsGetter(from: anyURLRequest())
            XCTFail("Should throw")
        } catch {
        }
    }
}
