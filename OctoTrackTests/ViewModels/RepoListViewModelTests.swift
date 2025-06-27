//
//  RepoListViewModelTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 27/06/2025.
//

import XCTest
import SwiftData
@testable import OctoTrack

@MainActor
final class RepoListViewModelTests: XCTestCase {
    var sut: RepoListViewModel!
    var dataManager: UserDataManager!
    var modelContext: ModelContext!
    var viewModelFactory: ViewModelFactory!
    
    override func setUp() async throws {
        try await super.setUp()
        (dataManager, modelContext) = UserDataManagerTestHelpers.createUserDataManager()
        viewModelFactory = ViewModelFactory(dataManager: dataManager)
        sut = RepoListViewModel(dataManager: dataManager, viewModelFactory: viewModelFactory)
    }
    
    override func tearDown() async throws {
        sut = nil
        dataManager = nil
        modelContext = nil
        viewModelFactory = nil
        try await super.tearDown()
    }

    // MARK: - Initialization Tests
    func test_init_setsInitialValues() {
        XCTAssertEqual(sut.selectedPriority, .all)
        XCTAssertEqual(sut.feedback, .none)
        XCTAssertNotNil(sut.dataManager)
        XCTAssertNotNil(sut.viewModelFactory)
    }

    // MARK: - Repository Selection Tests
    func test_selectedRepositories_returnsAllWhenPriorityIsAll() {
        UserDataManagerTestHelpers.createUserWithRepos(in: modelContext)
        sut.selectedPriority = .all
        
        XCTAssertGreaterThan(sut.selectedRepositories.count, 0)
    }
    
    func test_selectedRepositories_returnsSortedByMostRecent() {
        UserDataManagerTestHelpers.createUserWithRepos(in: modelContext)
        
        let repos = sut.selectedRepositories
        
        if repos.count > 1 {
            XCTAssertGreaterThanOrEqual(repos[0].mostRecentUpdate, repos[1].mostRecentUpdate)
        }
    }

    // MARK: - Delete Repository Tests
    func test_deleteRepository_removesRepositorySuccessfully() {
        let user = UserDataManagerTestHelpers.createUserWithRepos(in: modelContext)
        let repoToDelete = user.repoList.first!
        let initialCount = user.repoList.count
        
        sut.deleteRepository(repoToDelete)
        
        XCTAssertEqual(user.repoList.count, initialCount - 1)
        XCTAssertEqual(sut.feedback, .none)
    }

    // MARK: - Priority Filter Tests
    func test_selectedPriority_canBeChanged() {
        sut.selectedPriority = .high
        
        XCTAssertEqual(sut.selectedPriority, .high)
    }

    // MARK: - Feedback Tests
    func test_feedback_deleteFail_hasCorrectMessage() {
        sut.feedback = .deleteFail(repoName: testRepoName, error: "Test error")
        
        XCTAssertNotNil(sut.feedback.message)
        XCTAssertTrue(sut.feedback.isError)
    }
}
