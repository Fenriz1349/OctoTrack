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

    func getRepositoryList(with priority: RepoPriority) -> [Repository] {
        guard let activeUser = activeUser else { return [] }
        return priority == .all
        ? activeUser.repoList
        : activeUser.repoList.filter { $0.priority == priority}
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
        if let currentUser = activeUser, user.id == currentUser.id {
            currentUser.login = user.login
            currentUser.avatarURL = user.avatarURL
            currentUser.lastUpdate = Date()
            try? modelContext.save()
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
        guard !login.isEmpty, !avatarURL.isEmpty else { return nil }

        let newOwner = Owner(id: id, login: login, avatarURL: avatarURL)
        modelContext.insert(newOwner)
        return newOwner
    }

    // MARK: - Repository Methods

    // For now, we create a new repo and a new owner everytime to avoid conflicts
    func storeNewRepo(_ repo: Repository) throws {
        guard let currentUser = activeUser else { return }
        
        let newRepoId = "\(currentUser.id)_\(repo.id)".hashValue
           
       if currentUser.repoList.contains(where: { $0.id == newRepoId }) {
           return
       }
    
        let newOwner = Owner(
            id: "\(currentUser.id)_\(repo.owner.id)".hashValue,
            login: repo.owner.login,
            avatarURL: repo.owner.avatarURL
        )

        let newRepo = Repository(
            id: newRepoId,
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

    private func addExistingRepoToUser(repoId: Int, user: User) throws -> Bool {
        guard let existingRepo = try modelContext
            .fetch( FetchDescriptor<Repository>(predicate: #Predicate { $0.id == repoId })).first
        else { return false }

        guard !user.repoList.contains(where: { $0.id == repoId }) else { return true }

        user.repoList.append(existingRepo)
        user.lastUpdate = Date()
        try modelContext.save()

        return true
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

    func fetchExistingRepository(withId id: Int) throws -> Repository? {
        return try? modelContext.fetch(
            FetchDescriptor<Repository>(predicate: #Predicate { $0.id == id })
        ).first
    }

    func updateIfAlreayExist(_ repository: Repository) throws {
        guard let currentUser = activeUser else { return }

        if let existingRepo = try fetchExistingRepository(withId: repository.id) {
            if !currentUser.repoList.contains(where: { $0.id == repository.id }) {
                currentUser.repoList.append(existingRepo)
                currentUser.lastUpdate = Date()
                try modelContext.save()
            }
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
