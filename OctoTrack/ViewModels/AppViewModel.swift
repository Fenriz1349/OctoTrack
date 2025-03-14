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

    var authenticationViewModel: AuthenticationViewModel {
        return AuthenticationViewModel(
            onLoginSucceed: { [weak self] user in
                self?.loginUser(user: user)
            },
            onLogoutCompleted: { [weak self] in
                self?.logoutUser()
            }
        )
    }

    init() {
        isLogged = authenticationViewModel.isAuthenticated
               if isLogged && userApp == nil {
                   Task {
                       do {
                           userApp = try await authenticationViewModel.getUser()
                       } catch {
                           isLogged = false
                       }
                   }
               }
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
