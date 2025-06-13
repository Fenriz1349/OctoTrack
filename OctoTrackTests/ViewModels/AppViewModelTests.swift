//
//  AppViewModelTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
import SwiftData
@testable import OctoTrack

// Private func are not directly tested, catch are not beacause the need rework to inject dependecy
@MainActor
final class AppViewModelTests: XCTestCase {
    var sut: AppViewModel!
    var dataManager: UserDataManager!
    var modelContext: ModelContext!
    
    override func setUp() async throws {
        try await super.setUp()
        (dataManager, modelContext) = UserDataManagerTestHelpers.createUserDataManager()
        sut = AppViewModel(dataManager: dataManager)
    }
    
    override func tearDown() async throws {
        sut = nil
        dataManager = nil
        modelContext = nil
        try await super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_setsInitialValues() {
        XCTAssertEqual(sut.feedback, .none)
        XCTAssertFalse(sut.isLogged)
        XCTAssertTrue(sut.isInitializing)
        XCTAssertNotNil(sut.authenticationViewModel)
        XCTAssertNotNil(sut.dataManager)
    }

    func test_init_configuresCallbacks() {
        XCTAssertNotNil(sut.authenticationViewModel.onLoginSucceed)
        XCTAssertNotNil(sut.authenticationViewModel.onLogoutCompleted)
    }

    // MARK: - User Management Tests

    func test_loginUser_setsUserAsLoggedAndSavesUser() {
        let user = UserDataManagerTestHelpers.makeTestUser()
        
        sut.loginUser(user: user)
        
        XCTAssertTrue(sut.isLogged)
        XCTAssertNotNil(dataManager.activeUser)
        XCTAssertEqual(dataManager.activeUser?.id, user.id)
        XCTAssertTrue(dataManager.activeUser?.isActiveUser == true)
    }

    func test_logoutUser_setsUserAsLoggedOutAndDeactivatesUsers() {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        sut.isLogged = true
        
        sut.logoutUser()
        
        XCTAssertFalse(sut.isLogged)
        XCTAssertNil(dataManager.activeUser)
    }

    // MARK: - Repository Management Tests

    func test_resetUserRepository_resetsRepositoriesSuccessfully() {
        UserDataManagerTestHelpers.createUserWithRepos(in: modelContext)
        
        sut.resetUserRepository()
        
        XCTAssertEqual(sut.feedback, .resetSucessed)
        XCTAssertTrue(dataManager.activeUser?.repoList.isEmpty ?? false)
    }

    func test_resetUserRepository_setsFeedbackOnError() {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        
        sut.resetUserRepository()
        
        XCTAssertEqual(sut.feedback, .resetSucessed)
    }

    func test_checkIfEmptyRepoList_returnsFalseAndSetsFeedbackWhenEmpty() {
        UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        
        let result = sut.checkIfEmptyRepoList()
        
        XCTAssertFalse(result)
        XCTAssertEqual(sut.feedback, .emptyRepo)
    }

    func test_checkIfEmptyRepoList_returnsTrueWhenReposExist() {
        // Given
        UserDataManagerTestHelpers.createUserWithRepos(in: modelContext)
        
        // When
        let result = sut.checkIfEmptyRepoList()
        
        // Then
        XCTAssertTrue(result)
        XCTAssertEqual(sut.feedback, .none)
    }

    // MARK: - Feedback Tests

    func test_feedback_noneHasNoMessage() {
        sut.feedback = .none
        
        XCTAssertNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }

    func test_feedback_emptyRepoHasCorrectMessage() {
        sut.feedback = .emptyRepo
        
        XCTAssertNotNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }

    func test_feedback_resetSuccessedHasCorrectMessage() {
        sut.feedback = .resetSucessed
        
        XCTAssertNotNil(sut.feedback.message)
        XCTAssertFalse(sut.feedback.isError)
    }

    func test_feedback_resetFailedHasCorrectMessage() {
        sut.feedback = .resetFailed(error: "Database error")
        
        XCTAssertNotNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }

    func test_feedback_equatable() {
        let feedback1 = AppViewModel.Feedback.resetSucessed
        let feedback2 = AppViewModel.Feedback.resetSucessed
        let feedback3 = AppViewModel.Feedback.emptyRepo
        
        XCTAssertEqual(feedback1, feedback2)
        XCTAssertNotEqual(feedback1, feedback3)
    }

    // MARK: - Initialize Tests (Basic)

    func test_initialize_setsInitializingToFalse() async {
        sut.isInitializing = true
        
        await sut.initialize()
        
        XCTAssertFalse(sut.isInitializing)
    }

    // MARK: - State Management Tests

    func test_isLogged_canBeToggled() {
        XCTAssertFalse(sut.isLogged)
        
        sut.isLogged = true
        XCTAssertTrue(sut.isLogged)
        
        sut.isLogged = false
        XCTAssertFalse(sut.isLogged)
    }

    func test_isInitializing_canBeToggled() {
        XCTAssertTrue(sut.isInitializing)
        
        sut.isInitializing = false
        XCTAssertFalse(sut.isInitializing)
        
        sut.isInitializing = true
        XCTAssertTrue(sut.isInitializing)
    }
}
