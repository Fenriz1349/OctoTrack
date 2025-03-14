//
//  UserLoaderTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/03/2025.
//

import XCTest
@testable import OctoTrack

final class UserLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromClient() {
        let (_, client) = makeSUTUSer()

        XCTAssertTrue(client.requests.isEmpty)
    }

    func test_load_requestsDataFromURL() async {
        let request = anyURLRequest()
        let (sut, client) = makeSUTUSer()

        _ = try? await sut.userLoader(from: request)

        XCTAssertEqual(client.requests, [request])
    }

    func test_loadTwice_requestsDataFromURLTwice() async {
        let request = anyURLRequest()
        let (sut, client) = makeSUTUSer()

        _ = try? await sut.userLoader(from: request)
        _ = try? await sut.userLoader(from: request)

        XCTAssertEqual(client.requests, [request, request])
    }

    func test_load_deliversErrorOnClientError() async {
        let (sut, client) = makeSUTUSer(result: .failure(anyNSError()))

        do {
            _ = try await sut.userLoader(from: anyURLRequest())
            XCTFail("Expected error, got success instead")
        } catch {
        }
    }

    func test_load_deliversUserOnSuccessfulResponse() async throws {
        let user = makeUser()
        let data = try makeUserJSON(user.json)
        let (sut, client) = makeSUTUSer(result: .success((data, anyHTTPURLResponse())))

        let loadedUser = try await sut.userLoader(from: anyURLRequest())

        XCTAssertEqual(loadedUser.id, user.model.id)
        XCTAssertEqual(loadedUser.login, user.model.login)
        XCTAssertEqual(loadedUser.avatarURL, user.model.avatarURL)
    }
}
