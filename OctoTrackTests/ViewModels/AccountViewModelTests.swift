//
//  AccountViewModelTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 27/06/2025.
//

import XCTest
import SwiftData
@testable import OctoTrack

@MainActor
final class AccountViewModelTests: XCTestCase {
    var sut: AccountViewModel!
    var dataManager: UserDataManager!
    var modelContext: ModelContext!
    var authViewModel: AuthenticationViewModel!
    var viewModelFactory: ViewModelFactory!
    
    override func setUp() async throws {
        try await super.setUp()
        (dataManager, modelContext) = UserDataManagerTestHelpers.createUserDataManager()
        viewModelFactory = ViewModelFactory(dataManager: dataManager)
        authViewModel = AuthenticationViewModel(onLoginSucceed: { _ in }, onLogoutCompleted: { })
        sut = AccountViewModel(
            dataManager: dataManager,
            authenticationViewModel: authViewModel,
            viewModelFactory: viewModelFactory
        )
    }
    
    override func tearDown() async throws {
        sut = nil
        dataManager = nil
        modelContext = nil
        authViewModel = nil
        viewModelFactory = nil
        try await super.tearDown()
    }

    // MARK: - Initialization Tests
    func test_init_setsInitialValues() {
        XCTAssertFalse(sut.showingResetAlert)
        XCTAssertEqual(sut.feedback, .none)
        XCTAssertNotNil(sut.dataManager)
        XCTAssertNotNil(sut.authenticationViewModel)
        XCTAssertNotNil(sut.viewModelFactory)
    }

    // MARK: - Repository Count Tests
    func test_repositoryCount_returnsZeroWhenNoUser() {
        XCTAssertEqual(sut.repositoryCount, 0)
    }
    
    func test_repositoryCount_returnsCorrectCount() {
        UserDataManagerTestHelpers.createUserWithRepos(in: modelContext)
        
        XCTAssertGreaterThan(sut.repositoryCount, 0)
    }

    func test_resetUserRepository_setsSuccessFeedback() {
        UserDataManagerTestHelpers.createUserWithRepos(in: modelContext)
        
        sut.resetUserRepository()
        
        XCTAssertEqual(sut.feedback, .resetSucessed)
    }

    // MARK: - Feedback Tests
    func test_shouldShowFeedback_returnsTrueWhenFeedbackIsNotNone() {
        sut.feedback = .resetSucessed
        
        XCTAssertTrue(sut.shouldShowFeedback)
    }
    
    func test_shouldShowFeedback_returnsFalseWhenFeedbackIsNone() {
        sut.feedback = .none
        
        XCTAssertFalse(sut.shouldShowFeedback)
    }

    func test_resetFeedback_setsFeedbackToNone() {
        sut.feedback = .resetSucessed
        
        sut.resetFeedback()
        
        XCTAssertEqual(sut.feedback, .none)
    }

    // MARK: - Feedback Messages Tests
    func test_feedback_noneHasNoMessage() {
        sut.feedback = .none
        
        XCTAssertNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }

    func test_feedback_resetSuccessHasCorrectMessage() {
        sut.feedback = .resetSucessed
        
        XCTAssertNotNil(sut.feedback.message)
        XCTAssertFalse(sut.feedback.isError)
    }
    
    // MARK: - Check Empty Repo List Tests

    func test_checkIfEmptyRepoList_returnsFalseWhenRepoListIsEmpty() {
        UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        
        let result = sut.checkIfEmptyRepoList()
        
        XCTAssertFalse(result)
        XCTAssertEqual(sut.feedback, .emptyRepo)
    }

    func test_checkIfEmptyRepoList_returnsTrueWhenRepoListHasRepos() {
        UserDataManagerTestHelpers.createUserWithRepos(in: modelContext)
        
        let result = sut.checkIfEmptyRepoList()
        
        XCTAssertTrue(result)
        XCTAssertEqual(sut.feedback, .none)
    }

    func test_checkIfEmptyRepoList_returnsTrueWhenNoActiveUser() {
        // Pas d'utilisateur actif
        let result = sut.checkIfEmptyRepoList()
        
        XCTAssertTrue(result)
        XCTAssertEqual(sut.feedback, .none)
    }
    
    func test_logoutUser_deactivatesAllUsers() {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        XCTAssertTrue(user.isActiveUser)
        
        sut.logoutUser()
        
        XCTAssertFalse(user.isActiveUser)
        XCTAssertNil(dataManager.activeUser)
    }
}
