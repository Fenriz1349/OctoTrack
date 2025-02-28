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
        return AuthenticationViewModel { [weak self]  user in
            self?.loginUser(user: user)
        }
    }
    
    func loginUser(user: User) {
        self.isLogged = true
        self.userApp = user
    }
    
    func addRepoToUser(repo: Repository) {
        guard let user = userApp,
              !user.repoList.contains(where: { $0.id == repo.id }) else {
            return
        }
        userApp?.repoList.append(repo)
    }
}
