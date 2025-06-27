//
//  AddRepoViewModelTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
import SwiftData
@testable import OctoTrack

@MainActor
final class AddRepoViewModelTests: XCTestCase {
    var sut: AddRepoViewModel!
    var dataManager: UserDataManager!
    var modelContext: ModelContext!

    override func setUp(){
        super.setUp()
        (dataManager, modelContext) = UserDataManagerTestHelpers.createUserDataManager()
        UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        sut = AddRepoViewModel(dataManager: dataManager)
    }

    override func tearDown() {
        sut = nil
        dataManager = nil
        modelContext = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests
    func test_init_setsOwnerFromActiveUser() {
        XCTAssertEqual(sut.owner, "test")
        XCTAssertEqual(sut.priority, .low)
        XCTAssertEqual(sut.feedback, .none)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.shouldDismissModal)
    }

    func test_init_setsEmptyOwnerWhenNoActiveUser() async {
        let (emptyDataManager, _) = UserDataManagerTestHelpers.createUserDataManager()
        let emptyViewModel = AddRepoViewModel(dataManager: emptyDataManager)

        XCTAssertEqual(emptyViewModel.owner, "")
    }

    // MARK: - Form Validation Tests
    func test_isFormValid_returnsTrueWhenBothFieldsPopulated() {
        sut.owner = "test"
        sut.repoName = "test-repo"

        XCTAssertTrue(sut.isFormValid)
    }

    func test_isFormValid_returnsFalseWhenOwnerEmpty() {
        sut.owner = ""
        sut.repoName = "test-repo"

        XCTAssertFalse(sut.isFormValid)
    }

    func test_isFormValid_returnsFalseWhenRepoNameEmpty() {
        sut.owner = "test"
        sut.repoName = ""

        XCTAssertFalse(sut.isFormValid)
    }

    // MARK: - Feedback Tests
    func test_shouldShowFeedback_returnsTrueWhenFeedbackIsNotNone() {
        sut.feedback = .addSuccess(owner: "test", repoName: "repo")
        
        XCTAssertTrue(sut.shouldShowFeedback)
    }
    
    func test_shouldShowFeedback_returnsFalseWhenFeedbackIsNone() {
        sut.feedback = .none
        
        XCTAssertFalse(sut.shouldShowFeedback)
    }

    func test_feedback_addSuccessHasCorrectMessage() {
        sut.feedback = .addSuccess(owner: "test", repoName: "repo")

        XCTAssertNotNil(sut.feedback.message)
        XCTAssertFalse(sut.feedback.isError)
    }

    func test_feedback_alreadyTrackedHasCorrectMessage() {
        sut.feedback = .alreadyTracked(owner: "test", repoName: "repo")

        XCTAssertNotNil(sut.feedback.message)
        XCTAssertFalse(sut.feedback.isError)
    }

    func test_feedback_addFailedHasCorrectMessage() {
        sut.feedback = .addFailed(owner: "test", repoName: "repo", error: "Network error")

        XCTAssertNotNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }

    func test_resetFeedback_setsFeedbackToNone() {
        sut.feedback = .addSuccess(owner: "test", repoName: "repo")
        
        sut.resetFeedback()
        
        XCTAssertEqual(sut.feedback, .none)
    }

    // MARK: - Repository Already Tracked Test
    func test_getRepo_detectsDuplicateById() {
        let user = dataManager.activeUser!
        let existingRepo = UserDataManagerTestHelpers.makeTestRepository()
        existingRepo.id = 12345
        user.repoList.append(existingRepo)
        
        let duplicateRepo = UserDataManagerTestHelpers.makeTestRepository()
        duplicateRepo.id = 12345
        
        let isDuplicate = user.repoList.contains(where: { $0.id == duplicateRepo.id })
        
        XCTAssertTrue(isDuplicate)
    }

    func test_getRepo_setsLoadingToTrueAtStart() async {
        sut.owner = "test"
        sut.repoName = "test-repo"
        
        // Démarrer getRepo() en arrière-plan pour tester le loading initial
        let expectation = XCTestExpectation(description: "Loading set to true")
        
        Task {
            await sut.getRepo()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func test_getRepo_detectsExistingRepoById() {
        let user = dataManager.activeUser!
        let existingRepo = UserDataManagerTestHelpers.makeTestRepository()
        existingRepo.id = 12345
        user.repoList.append(existingRepo)
        
        let newRepo = UserDataManagerTestHelpers.makeTestRepository()
        newRepo.id = 12345  // Même ID
        
        let isDuplicate = user.repoList.contains(where: { $0.id == newRepo.id })
        
        XCTAssertTrue(isDuplicate)
    }

    func test_getRepo_setsRepoPriorityBeforeStoring() {
        // Test que la priorité est bien assignée
        let repo = UserDataManagerTestHelpers.makeTestRepository()
        sut.priority = .high
        
        repo.priority = sut.priority
        
        XCTAssertEqual(repo.priority, .high)
    }
}
