//
//  RepoEndpointTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 06/06/2025.
//

import XCTest
@testable import OctoTrack

final class RepoEndpointTests: XCTestCase {

    func test_request_buildsCorrectRequestWithToken() throws {
        // Given
        let request = try RepoEndpoint.request(owner: owner, repoName: name, token: token)

        // Then
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api.github.com")
        XCTAssertEqual(request.url?.path, "/repos/\(owner)/\(name)")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/vnd.github.v3+json")
    }

    func test_request_buildsCorrectRequestWithoutToken() throws {
        // Given
        let request = try RepoEndpoint.request(owner: owner, repoName: name)

        // Then
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api.github.com")
        XCTAssertEqual(request.url?.path, "/repos/\(owner)/\(name)")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.value(forHTTPHeaderField: "Authorization"))
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/vnd.github.v3+json")
    }
}
