//
//  UserHeaderViewModelTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 27/06/2025.
//

import XCTest
@testable import OctoTrack

final class UserHeaderViewModelTests: XCTestCase {
    var sut: UserHeaderViewModel!
    var testUser: User!
    
    override func setUp() {
        super.setUp()
        testUser = makeUser().model
        sut = UserHeaderViewModel(user: testUser, repoCount: 3)
    }
    
    override func tearDown() {
        sut = nil
        testUser = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests
    func test_init_setsPropertiesCorrectly() {
        XCTAssertEqual(sut.user.id, testUser.id)
        XCTAssertEqual(sut.repoCount, 3)
        XCTAssertEqual(sut.size, 100)
    }

    // MARK: - GitHub Link Tests
    func test_githubLink_returnsCorrectURL() {
        let expectedLink = "https://github.com/\(testUser.login)"
        
        XCTAssertEqual(sut.githubLink, expectedLink)
    }

    // MARK: - Tracked Repos Text Tests
    func test_trackedReposText_returnsNonEmptyTextForZero() {
        sut = UserHeaderViewModel(user: testUser, repoCount: 0)
        
        XCTAssertFalse(sut.trackedReposText.isEmpty)
    }

    func test_trackedReposText_returnsNonEmptyTextForOne() {
        sut = UserHeaderViewModel(user: testUser, repoCount: 1)
        
        XCTAssertFalse(sut.trackedReposText.isEmpty)
    }

    func test_trackedReposText_containsCountForMultiple() {
        sut = UserHeaderViewModel(user: testUser, repoCount: 5)
        
        XCTAssertTrue(sut.trackedReposText.contains("5"))
    }

    // MARK: - Formatted Last Update Tests
    func test_formattedLastUpdate_returnsNilWhenNoLastUpdate() {
        testUser.lastUpdate = nil
        sut = UserHeaderViewModel(user: testUser, repoCount: 3)
        
        XCTAssertNil(sut.formattedLastUpdate)
    }
    
    func test_formattedLastUpdate_returnsFormattedStringWhenLastUpdateExists() {
        testUser.lastUpdate = Date()
        sut = UserHeaderViewModel(user: testUser, repoCount: 3)
        
        XCTAssertNotNil(sut.formattedLastUpdate)
        XCTAssertTrue(sut.formattedLastUpdate!.contains("lastUpdate"))
    }
}
