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
    
    func getActiveUserRepositories() -> [Repository] {
        guard let activeUser = activeUser else { return [] }
        return activeUser.repoList
    }

    /// Use to always clear all users stored when logout so we always have only one user
    func clearUser(id: Int) {
        
        let predicate = #Predicate<User> {$0.id == id}
        if let user = try? modelContext.fetch(FetchDescriptor<User>(predicate: predicate)).first {
            modelContext.delete(user)
            try? modelContext.save()
        }
    }
    
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
            if let index = currentUser.repoList.firstIndex(where: { $0.id == id }) {
                let repoToDelete = currentUser.repoList[index]
                currentUser.repoList.remove(at: index)
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
}
