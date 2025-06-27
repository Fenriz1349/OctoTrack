//
//  RepoDetailsViewModelTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
import SwiftData
@testable import OctoTrack

@MainActor
final class RepoDetailsViewModelTests: XCTestCase {
    var sut: RepoDetailsViewModel!
    var dataManager: UserDataManager!
    var modelContext: ModelContext!
    var testRepo: Repository!
    
    override func setUp() async throws {
        try await super.setUp()
        (dataManager, modelContext) = UserDataManagerTestHelpers.createUserDataManager()
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        testRepo = UserDataManagerTestHelpers.makeTestRepository()
        testRepo.user = user
        user.repoList.append(testRepo)
        try! modelContext.save()
        sut = RepoDetailsViewModel(repository: testRepo, dataManager: dataManager)
    }
    
    override func tearDown() async throws {
        sut = nil
        dataManager = nil
        modelContext = nil
        testRepo = nil
        try await super.tearDown()
    }

    // MARK: - Initialization Tests
    func test_init_setsPropertiesCorrectly() {
        XCTAssertEqual(sut.repository.id, testRepo.id)
        XCTAssertEqual(sut.feedback, .none)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showPriorityPicker)
    }

    // MARK: - Feedback Tests
    func test_shouldShowFeedback_returnsTrueWhenFeedbackIsNotNone() {
        sut.feedback = .noPR
        
        XCTAssertTrue(sut.shouldShowFeedback)
    }
    
    func test_shouldShowFeedback_returnsFalseWhenFeedbackIsNone() {
        sut.feedback = .none
        
        XCTAssertFalse(sut.shouldShowFeedback)
    }

    // MARK: - Repository Priority Tests
    func test_updateRepositoryPriority_updatesPrioritySuccessfully() {
        sut.updateRepositoryPriority(.high)
        
        XCTAssertEqual(testRepo.priority, .high)
        XCTAssertEqual(sut.feedback, .none)
    }

    // MARK: - Pull Request Management Tests
    func test_deletePullRequest_removesPullRequestFromRepo() {
        let pullRequest = UserDataManagerTestHelpers.makeTestPullRequest()
        testRepo.pullRequests = [pullRequest]
        
        sut.deletePullRequest(pullRequest)
        
        XCTAssertTrue(testRepo.pullRequests.isEmpty)
        XCTAssertEqual(sut.feedback, .none)
    }

    // MARK: - Sorted Pull Requests Tests
    func test_sortedPullRequests_returnsSortedByCreationDate() {
        let pr1 = UserDataManagerTestHelpers.makeTestPullRequest()
        pr1.createdAt = Date().addingTimeInterval(-100)
        let pr2 = UserDataManagerTestHelpers.makeTestPullRequest()
        pr2.createdAt = Date()
        
        testRepo.pullRequests = [pr1, pr2]
        
        let sorted = sut.sortedPullRequests
        XCTAssertEqual(sorted.first?.createdAt, pr2.createdAt)
    }
}
