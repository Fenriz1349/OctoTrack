//
//  UserDataManager.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/03/2025.
//

import SwiftUI
import SwiftData

@Observable final class UserDataManager {
    var modelContext: ModelContext
    var isSucess: Bool = false

    init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }

    // MARK: - User Methods

    var activeUser: User? {
        do {
            let predicate = #Predicate<User> { $0.isActiveUser }
            let descriptor = FetchDescriptor<User>(predicate: predicate)
            return try modelContext.fetch(descriptor).first
        } catch {
            return nil
        }
    }

    var allUsers: [User] {
        do {
            return try modelContext.fetch(FetchDescriptor<User>())
        } catch {
            return []
        }
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
        // Update user info if it already exist
        if let currentUser = activeUser, user.id == currentUser.id {
            currentUser.login = user.login
            currentUser.avatarURL = user.avatarURL
            currentUser.lastUpdate = Date()
            try? modelContext.save()
            // Otherwise create it
        } else {
            modelContext.insert(user)
        }
        activateUser(user)
    }

    // MARK: - Owner Methods

    private func findOwner(id: Int) -> Owner? {
        try? modelContext.fetch(
            FetchDescriptor<Owner>(predicate: #Predicate { $0.id == id })
        ).first
    }

    private func createOwner(id: Int, login: String, avatarURL: String) -> Owner? {
        guard id != 0 && !login.isEmpty && !avatarURL.isEmpty else {
            return nil
        }

        let newOwner = Owner(id: id, login: login, avatarURL: avatarURL)
        modelContext.insert(newOwner)
        return newOwner
    }

    // MARK: - Repository Methods

    func storeNewRepo(_ repo: Repository) throws {
        guard let currentUser = activeUser else { return }
        let owner: Owner

        if let existingOwner = findOwner(id: repo.owner.id) {
            owner = existingOwner
        } else {
            guard let newOwner = createOwner(
                id: repo.owner.id,
                login: repo.owner.login,
                avatarURL: repo.owner.avatarURL
            ) else {
                return
            }
            owner = newOwner
            try modelContext.save()
        }

        let existingRepo = currentUser.repoList.first { $0.id == repo.id }

        if existingRepo == nil {
            let newRepo = Repository(
                id: repo.id,
                name: repo.name,
                repoDescription: repo.repoDescription,
                isPrivate: repo.isPrivate,
                owner: owner,
                createdAt: repo.createdAt,
                updatedAt: repo.updatedAt,
                language: repo.language,
                priority: repo.priority
            )

            modelContext.insert(newRepo)
            currentUser.repoList.append(newRepo)
            currentUser.lastUpdate = Date()

            try modelContext.save()
        }
    }

    func deleteRepository(_ repository: Repository) throws {
        guard let currentUser = activeUser else { return }

        if let repoToDelete = currentUser.repoList.first(where: { $0.id == repository.id }) {
            currentUser.repoList.removeAll { $0.id == repository.id }
            modelContext.delete(repoToDelete)
            try modelContext.save()
        }
    }

    func orderRepositories() {
        guard let currentUser = activeUser else { return }

        currentUser.repoList.sort { repo1, repo2 in
            let date1 = repo1.updatedAt ?? repo1.createdAt
            let date2 = repo2.updatedAt ?? repo2.createdAt
            return date1 > date2
        }
        try? modelContext.save()
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

extension UserDataManager {
    static var preview: UserDataManager {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Repository.self, configurations: config)
        return UserDataManager(modelContext: ModelContext(container))
    }
}
