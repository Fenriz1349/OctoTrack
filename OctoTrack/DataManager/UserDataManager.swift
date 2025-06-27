//
//  UserDataManager.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/03/2025.
//

import SwiftUI
import SwiftData

final class UserDataManager: ObservableObject {
    var modelContext: ModelContext
    @Published var isSucess: Bool = false

    var activeUser: User? {
        try? modelContext.fetch(FetchDescriptor<User>(predicate: #Predicate { $0.isActiveUser })).first
    }

    var allUsers: [User] {
        (try? modelContext.fetch(FetchDescriptor<User>())) ?? []
    }

    init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }

    // MARK: - User Methods

    func getRepositoryList(with priority: RepoPriority) -> [Repository] {
        guard let activeUser = activeUser else { return [] }
        return priority == .all
        ? activeUser.repoList
        : activeUser.repoList.filter { $0.priority == priority}
    }

    /// Deactivate all users except the one in parameter
    /// - Parameter user: the user to set as currentUser
    func activateUser(_ user: User) {
        deactivateAllUsers()
        user.isActiveUser = true
        user.lastUpdate = Date()
        try? modelContext.save()
    }

    func deactivateAllUsers() {
        allUsers.forEach { $0.isActiveUser = false }
        try? modelContext.save()
    }

    /// Create or update the currentUser
    /// - Parameter user: the user create when login
    func saveUser(_ user: User) {
        if let currentUser = activeUser, user.id == currentUser.id {
            currentUser.login = user.login
            currentUser.avatarURL = user.avatarURL
            currentUser.lastUpdate = Date()
            try? modelContext.save()
        } else {
            modelContext.insert(user)
            activateUser(user)
        }
    }

    // MARK: - Repository Methods

    // For now, we create a new repo and a new owner everytime to avoid conflicts
    func storeNewRepo(_ repo: Repository) throws {
        guard let currentUser = activeUser else { return }

        let uniqueRepoId = UUID().hashValue
        let uniqueOwnerId = UUID().hashValue

        if currentUser.repoList.contains(where: { $0.name == repo.name && $0.owner.login == repo.owner.login }) {
               return
           }

        let newOwner = Owner(
            id: uniqueOwnerId,
            login: repo.owner.login,
            avatarURL: repo.owner.avatarURL
        )

        let newRepo = Repository(
            id: uniqueRepoId,
            name: repo.name,
            repoDescription: repo.repoDescription,
            isPrivate: repo.isPrivate,
            owner: newOwner,
            createdAt: repo.createdAt,
            updatedAt: repo.updatedAt,
            language: repo.language,
            priority: repo.priority
        )
        newRepo.user = currentUser
        modelContext.insert(newOwner)
        modelContext.insert(newRepo)
        currentUser.repoList.append(newRepo)
        currentUser.lastUpdate = Date()

        try modelContext.save()
    }

    func deleteRepository(_ repository: Repository) throws {
        modelContext.delete(repository)
        try modelContext.save()
    }

    func resetAllRepositories() throws {
        guard let currentUser = activeUser else { return }

        let reposToDelete = currentUser.repoList
        currentUser.repoList.removeAll()
        for repo in reposToDelete {
            modelContext.delete(repo)
        }
        try modelContext.save()
    }

    func updateRepositoryPriority(repoId: Int, priority: RepoPriority) throws {
        guard let currentUser = activeUser else { return }

        if let repoToUpdate = currentUser.repoList.first(where: { $0.id == repoId }) {
            repoToUpdate.priority = priority
            try modelContext.save()
        }
    }

    // MARK: - Pull Request Methods

    func storePullRequests(_ pullRequests: [PullRequest], repositoryiD: Int) throws {
        guard let currentUser = activeUser else { return }

        if let index = currentUser.repoList.firstIndex(where: { $0.id == repositoryiD }) {
            let repoToUpdate = currentUser.repoList[index]
            repoToUpdate.pullRequests = pullRequests
            try modelContext.save()
        }
    }

    func deletePullRequest(repoId: Int, prId: Int) throws {
        guard let currentUser = activeUser else { return }

        if let repo = currentUser.repoList.first(where: { $0.id == repoId }),
           let pullRequest = repo.pullRequests.first(where: { $0.id == prId }) {
            repo.pullRequests.removeAll { $0.id == prId }
            modelContext.delete(pullRequest)
            try modelContext.save()
        }
    }
}
