//
//  RepoDetailsViewModelTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
import SwiftData
@testable import OctoTrack

// Catch in methods are not tested because they need rework
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
    }
    
    override func tearDown() async throws {
        sut = nil
        dataManager = nil
        modelContext = nil
        testRepo = nil
        try await super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_setsPropertiesCorrectly() async {
        sut = RepoDetailsViewModel(repository: testRepo, dataManager: dataManager)
        
        XCTAssertEqual(sut.repository.id, testRepo.id)
        XCTAssertEqual(sut.feedback, .none)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Repository Priority Tests

    func test_updateRepositoryPriority_updatesPrioritySuccessfully() async {
        sut = RepoDetailsViewModel(repository: testRepo, dataManager: dataManager)
        
        sut.updateRepositoryPriority(.high)
        
        XCTAssertEqual(testRepo.priority, .high)
        XCTAssertEqual(sut.feedback, .none)
    }

    // MARK: - Pull Request Management Tests

    func test_deletePullRequest_removesPullRequestFromRepo() async {
        sut = RepoDetailsViewModel(repository: testRepo, dataManager: dataManager)
        let pullRequest = UserDataManagerTestHelpers.makeTestPullRequest()
        testRepo.pullRequests = [pullRequest]
        
        sut.deletePullRequest(pullRequest)
        
        XCTAssertTrue(testRepo.pullRequests.isEmpty)
        XCTAssertEqual(sut.feedback, .none)
    }

    // MARK: - Feedback Tests

    func test_feedback_noneHasNoMessage() async {
        sut = RepoDetailsViewModel(repository: testRepo, dataManager: dataManager)
        sut.feedback = .none
        
        XCTAssertNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }

    func test_feedback_noPRHasCorrectMessage() async {
        sut = RepoDetailsViewModel(repository: testRepo, dataManager: dataManager)
        sut.feedback = .noPR
        
        XCTAssertNotNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }

    func test_feedback_updateFailedHasCorrectMessage() async {
        sut = RepoDetailsViewModel(repository: testRepo, dataManager: dataManager)
        sut.feedback = .updateFailed(error: "Network error")
        
        XCTAssertNotNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }

    func test_feedback_deleteFailedHasCorrectMessage() async {
        sut = RepoDetailsViewModel(repository: testRepo, dataManager: dataManager)
        sut.feedback = .deleteFailed(error: "Delete error")
        
        XCTAssertNotNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }

    func test_feedback_equatable() async {
        sut = RepoDetailsViewModel(repository: testRepo, dataManager: dataManager)
        let feedback1 = RepoDetailsViewModel.Feedback.none
        let feedback2 = RepoDetailsViewModel.Feedback.none
        let feedback3 = RepoDetailsViewModel.Feedback.noPR
        
        XCTAssertEqual(feedback1, feedback2)
        XCTAssertNotEqual(feedback1, feedback3)
    }

    // MARK: - State Management Tests

    func test_isLoading_canBeToggled() async {
        sut = RepoDetailsViewModel(repository: testRepo, dataManager: dataManager)
        
        XCTAssertFalse(sut.isLoading)
        
        sut.isLoading = true
        XCTAssertTrue(sut.isLoading)
        
        sut.isLoading = false
        XCTAssertFalse(sut.isLoading)
    }
}
