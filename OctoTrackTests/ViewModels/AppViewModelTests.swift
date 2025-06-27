//
//  AppViewModelTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
import SwiftData
@testable import OctoTrack

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

    // MARK: - Initialize Tests
    func test_initialize_setsInitializingToFalse() async {
        sut.isInitializing = true
        
        await sut.initialize()
        
        XCTAssertFalse(sut.isInitializing)
    }
}
