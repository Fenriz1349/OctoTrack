//
//  UserDataManager.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/03/2025.
//

import SwiftUI
import SwiftData

final class UserDataManager {
    var modelContext: ModelContext?

    /// Set the modelContext outside a view to get storedData
    /// - Parameter modelContext: the modelContext of the app
    func setModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    var activeUser: User? {
        guard let context = modelContext else { return nil }
           do {
               let predicate = #Predicate<User> { $0.isActiveUser }
               let descriptor = FetchDescriptor<User>(predicate: predicate)
               return try context.fetch(descriptor).first
           } catch {
               print("Erreur lors de la récupération de l'utilisateur: \(error)")
               return nil
           }
       }

    var allUsers: [User] {
        guard let context = modelContext else { return [] }
        do {
            return try context.fetch(FetchDescriptor<User>())
        } catch {
            return []
        }
    }

    /// Deactivate all users except the one in parameter
    /// - Parameter user: the user to set as currentUser
    func activateUser(_ user: User) {
        guard let context = modelContext else { return }
        deactivateAllUsers()
        user.isActiveUser = true
        user.lastUpdate = Date()
        try? context.save()
    }

    func deactivateAllUsers() {
        guard let context = modelContext else { return }
        allUsers.forEach { $0.isActiveUser = false }
        do {
            try context.save()
        } catch {
            return
        }
    }

    /// Create or update the currentUser
    /// - Parameter user: the user create when login
    func saveUser(_ user: User) {
        guard let context = modelContext else { return }
        // Update user info if it already exist
        if let storedUser = activeUser {
            storedUser.login = user.login
            storedUser.avatarURL = user.avatarURL
            storedUser.lastUpdate = Date()
            try? context.save()
        // Otherwise create it
        } else {
            context.insert(user)
        }
        activateUser(user)
    }

    /// Use to always clear all users stored when logout so we always have only one user
    func clearUser(id: Int) {
        guard let context = modelContext else { return }

            let predicate = #Predicate<User> {$0.id == id}
        if let user = try? context.fetch(FetchDescriptor<User>(predicate: predicate)).first {
            context.delete(user)
            try? context.save()
        }
    }
    
    func storeNewRepo(_ repo: Repository) {
        guard let currentUser = activeUser else { return }
        currentUser.repoList.append(repo)
        saveUser(currentUser)
    }
}
