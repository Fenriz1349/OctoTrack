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

    var currentUser: User? {
        guard let context = modelContext else { return nil }
           do {
               let users = try context.fetch(FetchDescriptor<User>())
               return users.first
           } catch {
               print("Erreur lors de la récupération de l'utilisateur: \(error)")
               return nil
           }
       }

    /// Create or update the currentUser
    /// - Parameter user: the user create when login
    func saveUser(_ user: User) {
        guard let context = modelContext else { return }
        // Update user info if it already exist
        if let storedUser = currentUser {
            storedUser.login = user.login
            storedUser.avatarURL = user.avatarURL
        // Otherwise create it
        } else {
            context.insert(user)
        }
        try? context.save()
    }

    /// Use to always clear all users stored when logout so we always have only one user
    func clearUsers() throws {
        guard let context = modelContext else { return }
        let users = try context.fetch(FetchDescriptor<User>())
        for user in users {
            context.delete(user)
        }
        try context.save()
    }
}
