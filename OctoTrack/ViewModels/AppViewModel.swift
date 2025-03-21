//
//  AppVC.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import SwiftUI

@MainActor
@Observable final class AppViewModel {
    
    var userApp: User?
    var isLogged: Bool = false
    var isInitializing: Bool = true
    var authenticationViewModel: AuthenticationViewModel

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

    @MainActor
    func initialize() async {
        isInitializing = true
        let authState = authenticationViewModel.authenticationState
           switch authState {
           case .authenticated:
               do {
                   userApp = try await authenticationViewModel.getUser()
                   isLogged = true
               } catch {
                   isLogged = false
               }
           case .expired:
               isLogged = false
           case .unauthenticated:
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
    }

    func addRepoToUser(repo: Repository) {
        guard let user = userApp,
              !user.repoList.contains(where: { $0.id == repo.id }) else {
            return
        }
        userApp?.repoList.append(repo)
    }
}
