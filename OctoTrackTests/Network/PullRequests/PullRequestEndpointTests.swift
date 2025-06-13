//
//  PullRequestEndpointTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
@testable import OctoTrack

final class PullRequestEndpointTests: XCTestCase {

    func test_request_callsEndpointBuilder() throws {
        // Given/When
        let request = try PullRequestEndpoint.request(owner: owner, repoName: name, token: token, state: "open")

        // Then
        XCTAssertEqual(request.url?.path, "/repos/\(owner)/\(name)/pulls")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
        XCTAssertTrue(request.url?.query?.contains("state=open") ?? false)
    }
}
