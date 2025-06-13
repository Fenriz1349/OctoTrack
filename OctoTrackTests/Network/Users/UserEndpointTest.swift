//
//  UserEndpointTest.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/03/2025.
//

import XCTest
@testable import OctoTrack

final class UserEndpointTests: XCTestCase {

    func test_userInfoRequest_createsRequestWithToken() throws {

        let request = try UserEndpoint.userInfoRequest(with: token)

        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api.github.com")
        XCTAssertEqual(request.url?.path, "/user")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(testToken)")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/vnd.github.v3+json")
    }
}
