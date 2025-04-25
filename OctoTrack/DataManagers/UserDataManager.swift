//
//  UserDataManager.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/03/2025.
//

import SwiftUI
import SwiftData

final class UserDataManager {
    var modelContext: ModelContext

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
            print("Erreur lors de la récupération de l'utilisateur: \(error)")
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
        do {
            try modelContext.save()
        } catch {
            return
        }
    }

    /// Create or update the currentUser
    /// - Parameter user: the user create when login
    func saveUser(_ user: User) {
        // Update user info if it already exist
        if let storedUser = activeUser {
            storedUser.login = user.login
            storedUser.avatarURL = user.avatarURL
            storedUser.lastUpdate = Date()
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
        do {
            let predicate = #Predicate<Owner> { owner in owner.id == id }
            let descriptor = FetchDescriptor<Owner>(predicate: predicate)
            return try modelContext.fetch(descriptor).first
        } catch {
            return nil
        }
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
        guard let currentUser = activeUser else { return }

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
                print("✅ Repo ajouté et sauvegardé: \(newRepo.name)")
            } else {
                print("⚠️ Ce repo est déjà associé à cet utilisateur")
            }
            print("📊 Nombre de repos associés à l'utilisateur: \(currentUser.repoList.count)")
        } catch {
            print("❌ Erreur: \(error)")
        }
    }

    func deleteRepo(id: Int) {
        guard let currentUser = activeUser else { return }
        do {
            if let repoToDelete = currentUser.repoList.first(where: { $0.id == id }) {
                currentUser.repoList.removeAll { $0.id == id }
                modelContext.delete(repoToDelete)
                try modelContext.save()
                print("✅ Repo supprimé avec succès")
            } else {
                print("⚠️ Repo non trouvé pour la suppression")
            }
        } catch {
            print("❌ Erreur lors de la suppression du repo: \(error)")
        }
    }

    func orderRepositories() {
        guard let currentUser = activeUser else { return }
        do {
            currentUser.repoList.sort { repo1, repo2 in
                let date1 = repo1.updatedAt ?? repo1.createdAt
                let date2 = repo2.updatedAt ?? repo2.createdAt
                return date1 < date2
            }
            try modelContext.save()
            print("✅ Repositories triés avec succès")
        } catch {
            print("❌ Erreur lors du tri des repositories: \(error)")
        }
    }

    func resetAllRepositories() {
        guard let currentUser = activeUser else { return }
        do {
            let reposToDelete = currentUser.repoList
            currentUser.repoList.removeAll()
            for repo in reposToDelete {
                modelContext.delete(repo)
            }
            try modelContext.save()
        } catch {
            print("erreur lors du reset")
        }
    }

    func updateRepositoryPriority(repoId: Int, priority: RepoPriority) {
        guard let currentUser = activeUser else { return }
        do {
            if let repoToUpdate = currentUser.repoList.first(where: { $0.id == repoId }) {
                repoToUpdate.priority = priority
                try modelContext.save()
                print("✅ Repo mis à jour avec succès")
            } else {
                print("⚠️ Repo non trouvé pour la mise à jour")
            }
        } catch {
            print("❌ Erreur lors de la mise à jour du repo: \(error)")
        }
    }

    // MARK: - Pull Request Methods

    func storePullRequests(_ pullRequests: [PullRequest], repositoryiD: Int) {
        guard let currentUser = activeUser else { return }
        do {
            if let index = currentUser.repoList.firstIndex(where: { $0.id == repositoryiD }) {
                let repoToUpdate = currentUser.repoList[index]
                repoToUpdate.pullRequests = pullRequests
                try modelContext.save()
                print("liste des PullRequests sauvegardé")
            }
        } catch {
            print("Erreur dans la sauvegarde des PulleEquests")
        }
    }

    func deletePullRequest(repoId: Int, prId: Int) {
        guard let currentUser = activeUser else { return }
        do {
            if let repo = currentUser.repoList.first(where: { $0.id == repoId }) {
                if let pullRequest = repo.pullRequests.first(where: { $0.id == prId }) {
                    repo.pullRequests.removeAll { $0.id == prId }
                    modelContext.delete(pullRequest)
                    try modelContext.save()
                    print("✅ Pull Request supprimé avec succès")
                }
            } else {
                print("⚠️ Pull Request non trouvé pour la suppression")
            }
        } catch {
            print("❌ Erreur lors de la suppression de la pull request: \(error)")
        }
    }
}
