//
//  RepoGetterTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 06/06/2025.
//

import XCTest
@testable import OctoTrack

final class RepoGetterTests: XCTestCase {

    func test_repoGetter_success() async throws {
        // Given
        let (expectedRepo, repoData) = makeRepositoryResponse()
        let client = HTTPClientStub(result: .success((repoData, anyHTTPURLResponse())))
        let sut = RepoGetter(client: client)

        // When
        let repo = try await sut.repoGetter(from: anyURLRequest())

        // Then
        XCTAssertEqual(repo.id, expectedRepo.id)
        XCTAssertEqual(repo.name, expectedRepo.name)
        XCTAssertEqual(client.requests.count, 1)
    }

    func test_repoGetter_failure() async {
        // Given
        let client = HTTPClientStub(result: .failure(anyNSError()))
        let sut = RepoGetter(client: client)

        // When/Then
        do {
            _ = try await sut.repoGetter(from: anyURLRequest())
            XCTFail("Should throw")
        } catch {
            // Expected
        }
    }
}
