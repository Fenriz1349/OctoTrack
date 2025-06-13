//
//  UserDataManagerTestHelpers.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
import SwiftData
@testable import OctoTrack

class UserDataManagerTestHelpers {
    
    static func createInMemoryModelContext() -> ModelContext {
        let schema = Schema([User.self, Repository.self, Owner.self, PullRequest.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        return ModelContext(container)
    }
    
    static func createUserDataManager() -> (UserDataManager, ModelContext) {
        let modelContext = createInMemoryModelContext()
        let dataManager = UserDataManager(modelContext: modelContext)
        return (dataManager, modelContext)
    }
    
    static func createActiveUser(in modelContext: ModelContext) -> User {
        let user = User(id: 1, login: "test", avatarURL: "url", repoList: [])
        user.isActiveUser = true
        modelContext.insert(user)
        try! modelContext.save()
        return user
    }
    
    static func createTestUsers(in modelContext: ModelContext) -> (User, User) {
        let user1 = User(id: 1, login: "user1", avatarURL: "url1", repoList: [])
        let user2 = User(id: 2, login: "user2", avatarURL: "url2", repoList: [])
        modelContext.insert(user1)
        modelContext.insert(user2)
        try! modelContext.save()
        return (user1, user2)
    }
    
    static func createUserWithRepos(in modelContext: ModelContext) -> User {
        let user = createActiveUser(in: modelContext)
        let owner = Owner(id: 1, login: "owner", avatarURL: "url")
        let repo1 = Repository(id: 1, name: "repo1", isPrivate: false, owner: owner, createdAt: Date(), priority: .low)
        let repo2 = Repository(id: 2, name: "repo2", isPrivate: false, owner: owner, createdAt: Date(), priority: .high)
        repo1.user = user
        repo2.user = user
        user.repoList = [repo1, repo2]
        modelContext.insert(owner)
        modelContext.insert(repo1)
        modelContext.insert(repo2)
        try! modelContext.save()
        return user
    }
    
    static func makeTestUser(id: Int = 1, login: String = "test", avatarURL: String = "url") -> User {
        return User(id: id, login: login, avatarURL: avatarURL, repoList: [])
    }
    
    static func makeTestOwner(id: Int = 1, login: String = "owner", avatarURL: String = "url") -> Owner {
        return Owner(id: id, login: login, avatarURL: avatarURL)
    }
    
    static func makeTestRepository(id: Int = 12345, name: String = "test-repo", priority: RepoPriority = .low) -> Repository {
        let owner = makeTestOwner()
        return Repository(
            id: id,
            name: name,
            repoDescription: "Test description",
            isPrivate: false,
            owner: owner,
            createdAt: Date(),
            updatedAt: Date(),
            language: "Swift",
            priority: priority
        )
    }
    
    static func makeTestPullRequest(id: Int = 1, number: Int = 1, title: String = "Test PR") -> PullRequest {
        return PullRequest(
            id: id,
            number: number,
            body: "Test body",
            title: title,
            createdAt: Date(),
            updateAt: Date(),
            closedAt: nil,
            mergedAt: nil,
            isDraft: false
        )
    }
}
