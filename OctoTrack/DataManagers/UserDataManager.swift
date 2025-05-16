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
    var feedbackMessage: String?
    var isSucess: Bool = false

    init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }

    // MARK: - User Methods

    var activeUser: User {
        do {
            let predicate = #Predicate<User> { $0.isActiveUser }
            let descriptor = FetchDescriptor<User>(predicate: predicate)
            guard let user = try modelContext.fetch(descriptor).first else {
                fatalError("noActiveUser")
            }
            return user
        } catch {
            fatalError("Erreur lors de la récupération de l'utilisateur: \(error.localizedDescription)")
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

    /// Used when we log, and we are not sure there is an activeUser
    /// - Returns: The activeUser, or nil if noone is active
    func safeActiveUser() -> User? {
        do {
            let predicate = #Predicate<User> { $0.isActiveUser }
            let descriptor = FetchDescriptor<User>(predicate: predicate)
            return try modelContext.fetch(descriptor).first
        } catch {
            feedbackMessage = "Erreur lors de la récupération de l'utilisateur: \(error.localizedDescription)"
            return nil
        }
    }

    func deactivateAllUsers() {
        allUsers.forEach { $0.isActiveUser = false }
        try? modelContext.save()
    }

    /// Create or update the currentUser
    /// - Parameter user: the user create when login
    func saveUser(_ user: User) {
        // Update user info if it already exist
        if user.id == activeUser.id {
            activeUser.login = user.login
            activeUser.avatarURL = user.avatarURL
            activeUser.lastUpdate = Date()
            try? modelContext.save()
            // Otherwise create it
        } else {
            modelContext.insert(user)
        }
        activateUser(user)
    }

    /// Use to always clear all users stored when logout so we always have only one user
    func clearUser(id: Int) {
        let predicate = #Predicate<User> {$0.id == id}
        if let user = try? modelContext.fetch(FetchDescriptor<User>(predicate: predicate)).first {
            modelContext.delete(user)
            try? modelContext.save()
        }
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

    func storeNewRepo(_ repo: Repository) {
        do {
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

            let existingRepo = activeUser.repoList.first { $0.id == repo.id }

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
                activeUser.repoList.append(newRepo)
                activeUser.lastUpdate = Date()

                try modelContext.save()
            }
        } catch {
            feedbackMessage = error.localizedDescription
        }
    }

    func deleteRepository(_ repository: Repository) throws {
        if let repoToDelete = activeUser.repoList.first(where: { $0.id == repository.id }) {
            activeUser.repoList.removeAll { $0.id == repository.id }
            modelContext.delete(repoToDelete)
            try modelContext.save()
        }
    }

    func orderRepositories() {
        activeUser.repoList.sort { repo1, repo2 in
            let date1 = repo1.updatedAt ?? repo1.createdAt
            let date2 = repo2.updatedAt ?? repo2.createdAt
            return date1 > date2
        }
        try? modelContext.save()
    }

    func resetAllRepositories() {
        do {
            let reposToDelete = activeUser.repoList
            activeUser.repoList.removeAll()
            for repo in reposToDelete {
                modelContext.delete(repo)
            }
            try modelContext.save()
            feedbackMessage = "resetSuccess"
        } catch {
            feedbackMessage = "resetFailed"
        }
    }

    func updateRepositoryPriority(repoId: Int, priority: RepoPriority) {
        do {
            if let repoToUpdate = activeUser.repoList.first(where: { $0.id == repoId }) {
                repoToUpdate.priority = priority
                try modelContext.save()
            }
        } catch {
            feedbackMessage = "updateFailed"
        }
    }

    // MARK: - Pull Request Methods

    func storePullRequests(_ pullRequests: [PullRequest], repositoryiD: Int) {
        do {
            if let index = activeUser.repoList.firstIndex(where: { $0.id == repositoryiD }) {
                let repoToUpdate = activeUser.repoList[index]
                repoToUpdate.pullRequests = pullRequests
                try modelContext.save()
            }
        } catch {
            feedbackMessage = "insertFailed"
        }
    }

    func deletePullRequest(repoId: Int, prId: Int) {
        do {
            if let repo = activeUser.repoList.first(where: { $0.id == repoId }),
               let pullRequest = repo.pullRequests.first(where: { $0.id == prId }) {
                repo.pullRequests.removeAll { $0.id == prId }
                modelContext.delete(pullRequest)
                try modelContext.save()
            }
        } catch {
            feedbackMessage = "deleteFailed"
        }
    }
}
