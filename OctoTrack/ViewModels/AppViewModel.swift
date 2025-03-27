//
//  AppVC.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import SwiftUI
import SwiftData

@MainActor
@Observable final class AppViewModel {
    var userApp: User?
    var isLogged: Bool = false
    var isInitializing: Bool = true
    var authenticationViewModel: AuthenticationViewModel
    var dataManager = UserDataManager()

    init() {
        self.authenticationViewModel = AuthenticationViewModel(
            onLoginSucceed: { _ in },
            onLogoutCompleted: { }
        )

        configureCallbacks()
    }

    private func configureCallbacks() {
           let newViewModel = AuthenticationViewModel(
               onLoginSucceed: { [weak self] user in
                   self?.loginUser(user: user)
               },
               onLogoutCompleted: { [weak self] in
                   self?.logoutUser()
               }
           )

           self.authenticationViewModel = newViewModel
       }

    /// The main function to initilialize the app
    /// First check the authentication status
    /// If authenticate, cherck if there is a stored user, otherwiese get it with the authenticator
    /// if expired or unauthenticated set isLogged to false to display the AuthenticationView
    @MainActor
    func initialize() async {
        isInitializing = true
        let authState = authenticationViewModel.authenticationState

           switch authState {
           case .authenticated:
               if let storedUser = dataManager.currentUser {
                   userApp = storedUser
                   isLogged = true
               } else {
                   do {
                       userApp = try await authenticationViewModel.getUser()
                       dataManager.saveUser(userApp!)
                       isLogged = true
                   } catch {
                       isLogged = false
                   }
               }
           case .expired, .unauthenticated:
               isLogged = false
           }
        isInitializing = false
    }

    func loginUser(user: User) {
        self.isLogged = true
        self.userApp = user
    }

    func logoutUser() {
        self.isLogged = false
        self.userApp = nil
        try? dataManager.clearUsers()
    }

    func addRepoToUser(repo: Repository) {
        guard let user = userApp,
              !user.repoList.contains(where: { $0.id == repo.id }) else {
            return
        }
        userApp?.repoList.append(repo)
    }
}
