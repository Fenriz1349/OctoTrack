//
//  UserDataManagerTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
import SwiftData
@testable import OctoTrack

final class UserDataManagerTests: XCTestCase {
    var modelContext: ModelContext!
    var sut: UserDataManager!
    
    override func setUp() {
        super.setUp()
        (sut, modelContext) = UserDataManagerTestHelpers.createUserDataManager()
    }
    
    override func tearDown() {
        modelContext = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - User Methods Tests

    func test_activeUser_returnsNilWhenNoActiveUser() {
        let activeUser = sut.activeUser
        
        XCTAssertNil(activeUser)
    }

    func test_activeUser_returnsUserWhenActiveUserExists() {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        
        let activeUser = sut.activeUser
        
        XCTAssertNotNil(activeUser)
        XCTAssertEqual(activeUser?.id, 1)
        XCTAssertTrue(activeUser?.isActiveUser == true)
    }

    func test_activeUser_returnsNilOnFetchError() {
        modelContext = UserDataManagerTestHelpers.createInMemoryModelContext()
        
        // When
        let activeUser = sut.activeUser
        
        // Then
        XCTAssertNil(activeUser)
    }

    func test_getRepositoryList_returnsEmptyWhenNoActiveUser() {
        let repos = sut.getRepositoryList(with: .all)
        
        XCTAssertTrue(repos.isEmpty)
    }

    func test_getRepositoryList_returnsAllReposWhenPriorityAll() {
        let user = UserDataManagerTestHelpers.createUserWithRepos(in: modelContext)
        
        let repos = sut.getRepositoryList(with: .all)
        
        XCTAssertEqual(repos.count, 2)
    }

    func test_getRepositoryList_filtersReposByPriority() {
        let user = UserDataManagerTestHelpers.createUserWithRepos(in: modelContext)
        
        let highPriorityRepos = sut.getRepositoryList(with: .high)
        
        XCTAssertEqual(highPriorityRepos.count, 1)
        XCTAssertEqual(highPriorityRepos.first?.priority, .high)
    }

    func test_allUsers_returnsAllUsersFromContext() {
        let users = UserDataManagerTestHelpers.createTestUsers(in: modelContext)
        
        let allUsers = sut.allUsers
        
        XCTAssertEqual(allUsers.count, 2)
    }

    func test_activateUser_setsUserAsActiveAndDeactivatesOthers() {
        let users = UserDataManagerTestHelpers.createTestUsers(in: modelContext)
        let userToActivate = users.1
        
        sut.activateUser(userToActivate)
        
        XCTAssertTrue(userToActivate.isActiveUser)
        XCTAssertFalse(users.0.isActiveUser)
        XCTAssertNotNil(userToActivate.lastUpdate)
    }

    func test_deactivateAllUsers_setsAllUsersAsInactive() {
        let users = UserDataManagerTestHelpers.createTestUsers(in: modelContext)
        users.0.isActiveUser = true
        users.1.isActiveUser = true
        
        sut.deactivateAllUsers()
        
        XCTAssertFalse(users.0.isActiveUser)
        XCTAssertFalse(users.1.isActiveUser)
    }

    func test_saveUser_updatesExistingUser() {
        let existingUser = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        let updatedUser = UserDataManagerTestHelpers.makeTestUser(id: 1, login: "new", avatarURL: "new")
        
        sut.saveUser(updatedUser)
        
        let activeUser = sut.activeUser
        XCTAssertEqual(activeUser?.login, "new")
        XCTAssertEqual(activeUser?.avatarURL, "new")
        XCTAssertNotNil(activeUser?.lastUpdate)
    }

    func test_saveUser_insertsNewUser() {
        let newUser = UserDataManagerTestHelpers.makeTestUser()
        
        sut.saveUser(newUser)
        
        let activeUser = sut.activeUser
        XCTAssertNotNil(activeUser)
        XCTAssertEqual(activeUser?.id, 1)
        XCTAssertTrue(activeUser?.isActiveUser == true)
    }

    // MARK: - Repository Methods Tests

    func test_storeNewRepo_createsOwnerWithUniqueId() throws {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        let repo = UserDataManagerTestHelpers.makeTestRepository()
        let originalOwnerId = repo.owner.id
        
        try sut.storeNewRepo(repo)
        
        let createdRepo = user.repoList.first!
        XCTAssertNotEqual(createdRepo.owner.id, originalOwnerId)
        XCTAssertEqual(createdRepo.owner.login, repo.owner.login)
        XCTAssertEqual(createdRepo.owner.avatarURL, repo.owner.avatarURL)
    }

    func test_storeNewRepo_doesNotAddDuplicateRepo() throws {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        let repo = UserDataManagerTestHelpers.makeTestRepository()
        try sut.storeNewRepo(repo)
        
        try sut.storeNewRepo(repo)
        
        XCTAssertEqual(user.repoList.count, 1)
    }

    func test_storeNewRepo_createsRepoWithUniqueId() throws {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        let repo = UserDataManagerTestHelpers.makeTestRepository()
        let originalRepoId = repo.id
        
        try sut.storeNewRepo(repo)
        
        let createdRepo = user.repoList.first!
        XCTAssertNotEqual(createdRepo.id, originalRepoId)
        XCTAssertEqual(user.repoList.count, 1)
    }

    func test_storeNewRepo_linksRepoToUser() throws {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        let repo = UserDataManagerTestHelpers.makeTestRepository()
        
        try sut.storeNewRepo(repo)
        
        let createdRepo = user.repoList.first!
        XCTAssertEqual(createdRepo.user?.id, user.id)
    }

    func test_deleteRepository_removesRepoFromContext() throws {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        let repo = UserDataManagerTestHelpers.makeTestRepository()
        try sut.storeNewRepo(repo)
        let createdRepo = user.repoList.first!
        
        try sut.deleteRepository(createdRepo)
        
        XCTAssertTrue(user.repoList.isEmpty)
    }

    func test_resetAllRepositories_removesAllReposFromUser() throws {
        let user = UserDataManagerTestHelpers.createUserWithRepos(in: modelContext)
        
        try sut.resetAllRepositories()
        
        XCTAssertTrue(user.repoList.isEmpty)
    }

    func test_updateRepositoryPriority_updatesRepoPriority() throws {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        let repo = UserDataManagerTestHelpers.makeTestRepository()
        try sut.storeNewRepo(repo)
        let createdRepo = user.repoList.first!
        
        try sut.updateRepositoryPriority(repoId: createdRepo.id, priority: .high)
        
        XCTAssertEqual(createdRepo.priority, .high)
    }

    // MARK: - Pull Request Methods Tests

    func test_storePullRequests_addsPullRequestsToRepo() throws {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        let repo = UserDataManagerTestHelpers.makeTestRepository()
        try sut.storeNewRepo(repo)
        let createdRepo = user.repoList.first!
        let pullRequests = [UserDataManagerTestHelpers.makeTestPullRequest()]
        
        try sut.storePullRequests(pullRequests, repositoryiD: createdRepo.id)
        
        XCTAssertEqual(createdRepo.pullRequests.count, 1)
        XCTAssertEqual(createdRepo.pullRequests.first?.title, "Test PR")
    }

    func test_deletePullRequest_removesPullRequestFromRepo() throws {
        let user = UserDataManagerTestHelpers.createActiveUser(in: modelContext)
        let repo = UserDataManagerTestHelpers.makeTestRepository()
        try sut.storeNewRepo(repo)
        let createdRepo = user.repoList.first!
        let pullRequest = UserDataManagerTestHelpers.makeTestPullRequest()
        try sut.storePullRequests([pullRequest], repositoryiD: createdRepo.id)
        
        try sut.deletePullRequest(repoId: createdRepo.id, prId: pullRequest.id)
        
        XCTAssertTrue(createdRepo.pullRequests.isEmpty)
    }
}
