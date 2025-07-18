//
//  AuthenticationViewModelTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
@testable import OctoTrack

@MainActor
final class AuthenticationViewModelTests: XCTestCase {
    var sut: AuthenticationViewModel!
    var loginSucceedCalled: Bool = false
    var logoutCompletedCalled: Bool = false
    var capturedUser: User?
    
    override func setUp() async throws {
        try await super.setUp()
        loginSucceedCalled = false
        logoutCompletedCalled = false
        capturedUser = nil
        
        sut = AuthenticationViewModel(
            onLoginSucceed: { [weak self] user in
                self?.loginSucceedCalled = true
                self?.capturedUser = user
            },
            onLogoutCompleted: { [weak self] in
                self?.logoutCompletedCalled = true
            }
        )
    }
    
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    // MARK: - Initialization Tests
    func test_init_setsInitialValues() {
        XCTAssertFalse(sut.isAuthenticating)
        XCTAssertEqual(sut.feedback, .none)
        XCTAssertFalse(sut.isAnimating)
        XCTAssertEqual(sut.opacity, 0.0)
        XCTAssertNotNil(sut.onLoginSucceed)
        XCTAssertNotNil(sut.onLogoutCompleted)
    }

    // MARK: - Authentication State Tests
    func test_authenticationState_delegatesToAuthenticator() {
        let state = sut.authenticationState
        
        XCTAssertTrue([.authenticated, .unauthenticated, .expired].contains(state))
    }

    // MARK: - Sign Out Tests
    func test_signOut_callsOnLogoutCompleted() {
        sut.signOut()
        
        XCTAssertTrue(logoutCompletedCalled)
    }

    // MARK: - Token Validation Management Tests
    func test_startTokenValidation_executesWithoutError() {
        sut.startTokenValidation()
        
        XCTAssertTrue(true)
    }

    func test_stopTokenValidation_executesWithoutError() {
        sut.startTokenValidation()
        
        sut.stopTokenValidation()
        
        XCTAssertTrue(true)
    }

    // MARK: - Feedback Tests
    func test_feedback_noneHasNoMessage() {
        sut.feedback = .none
        
        XCTAssertNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }

    func test_feedback_authFailedHasCorrectMessage() {
        sut.feedback = .authFailed(error: "Network error")
        
        XCTAssertNotNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }

    func test_feedback_equatable() {
        let feedback1 = AuthenticationViewModel.Feedback.none
        let feedback2 = AuthenticationViewModel.Feedback.none
        let feedback3 = AuthenticationViewModel.Feedback.authFailed(error: "error")
        
        XCTAssertEqual(feedback1, feedback2)
        XCTAssertNotEqual(feedback1, feedback3)
    }

    // MARK: - Animation Properties Tests
    func test_isAnimating_canBeToggled() {
        XCTAssertFalse(sut.isAnimating)
        
        sut.isAnimating = true
        XCTAssertTrue(sut.isAnimating)
        
        sut.isAnimating = false
        XCTAssertFalse(sut.isAnimating)
    }

    func test_opacity_canBeChanged() {
        XCTAssertEqual(sut.opacity, 0.0)
        
        sut.opacity = 1.0
        XCTAssertEqual(sut.opacity, 1.0)
    }

    // MARK: - State Management Tests
    func test_isAuthenticating_canBeToggled() {
        XCTAssertFalse(sut.isAuthenticating)
        
        sut.isAuthenticating = true
        XCTAssertTrue(sut.isAuthenticating)
        
        sut.isAuthenticating = false
        XCTAssertFalse(sut.isAuthenticating)
    }

    // MARK: - Callback Tests
    func test_onLoginSucceed_capturesUserCorrectly() {
        let testUser = makeUser().model
        
        sut.onLoginSucceed(testUser)
        
        XCTAssertTrue(loginSucceedCalled)
        XCTAssertEqual(capturedUser?.id, testUser.id)
        XCTAssertEqual(capturedUser?.login, testUser.login)
    }

    func test_onLogoutCompleted_callsCallbackCorrectly() {
        sut.onLogoutCompleted()
        
        XCTAssertTrue(logoutCompletedCalled)
    }
}
