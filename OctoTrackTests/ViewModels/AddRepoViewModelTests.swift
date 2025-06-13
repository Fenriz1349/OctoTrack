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

    func test_init_setsOwnerFromActiveUser() {
        XCTAssertEqual(sut.owner, "test")
        XCTAssertEqual(sut.priority, .low)
        XCTAssertEqual(sut.feedback, .none)
        XCTAssertFalse(sut.isLoading)
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

    func test_isFormValid_returnsFalseWhenBothFieldsEmpty() {
        sut.owner = ""
        sut.repoName = ""

        XCTAssertFalse(sut.isFormValid)
    }

    // MARK: - GetRepo Tests

    func test_getRepo_setsAlreadyTrackedWhenRepoExists() async {
        let user = dataManager.activeUser!
        let existingRepo = UserDataManagerTestHelpers.makeTestRepository()
        existingRepo.name = "existing-repo"
        existingRepo.owner.login = "test"
        user.repoList.append(existingRepo)

        sut.owner = "test"
        sut.repoName = "existing-repo"

        await sut.getRepo()

        XCTAssertEqual(sut.feedback, .alreadyTracked(owner: "test", repoName: "existing-repo"))
        XCTAssertFalse(sut.isLoading)
    }

    func test_getRepo_setsAddFailedOnError() async {
        sut.owner = "nonexistent"
        sut.repoName = "nonexistent"

        await sut.getRepo()

        switch sut.feedback {
        case .addFailed(let owner, let repoName, _):
            XCTAssertEqual(owner, "nonexistent")
            XCTAssertEqual(repoName, "nonexistent")
        default:
            XCTFail("Expected addFailed feedback")
        }
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Feedback Tests

    func test_feedback_noneHasNoMessage() {
        sut.feedback = .none

        XCTAssertNil(sut.feedback.message)
        XCTAssertFalse(sut.feedback.isError)
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

    func test_feedback_equatable() {
        let feedback1 = AddRepoViewModel.Feedback.addSuccess(owner: "test", repoName: "repo")
        let feedback2 = AddRepoViewModel.Feedback.addSuccess(owner: "test", repoName: "repo")
        let feedback3 = AddRepoViewModel.Feedback.addFailed(owner: "test", repoName: "repo", error: "error")

        XCTAssertEqual(feedback1, feedback2)
        XCTAssertNotEqual(feedback1, feedback3)
    }

    // MARK: - Priority Tests

    func test_priority_canBeChanged() {
        sut.priority = .high

        XCTAssertEqual(sut.priority, .high)
    }

    func test_priority_defaultsToLow() {
        XCTAssertEqual(sut.priority, .low)
    }
}
