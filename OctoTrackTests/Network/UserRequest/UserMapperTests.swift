//
//  UserMapperTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/03/2025.
//

import XCTest
@testable import OctoTrack

final class UserMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = try makeUserJSON(makeUser().json)
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try UserMapper.map(json, and: anyHTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOnInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)

        XCTAssertThrowsError(
            try UserMapper.map(invalidJSON, and: anyHTTPURLResponse())
        )
    }

    func test_map_deliversUserOn200HTTPResponseWithValidJSON() throws {
        let user = makeUser()
        let json = try makeUserJSON(user.json)

        let result = try UserMapper.map(json, and: anyHTTPURLResponse())

        XCTAssertEqual(result.id, user.model.id)
        XCTAssertEqual(result.login, user.model.login)
        XCTAssertEqual(result.avatarURL, user.model.avatarURL)
    }
}
