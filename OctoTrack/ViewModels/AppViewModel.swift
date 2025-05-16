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
    var isLogged: Bool = false
    var isInitializing: Bool = true
    var authenticationViewModel: AuthenticationViewModel
    let dataManager: UserDataManager

    init(dataManager: UserDataManager) {
        self.dataManager = dataManager
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
            await loadUserData()
            if dataManager.safeActiveUser() != nil {
                isLogged = true
                authenticationViewModel.startTokenValidation()
            } else {
                isLogged = false
            }
        case .expired:
            if await authenticationViewModel.isTokenValid() {
                try? authenticationViewModel.refreshToken()
                await loadUserData()
                authenticationViewModel.startTokenValidation()
            } else {
                logoutUser()
            }
        case .unauthenticated:
            logoutUser()
        }
        isInitializing = false
    }

    func loginUser(user: User) {
        self.isLogged = true
        dataManager.saveUser(user)
    }

    func logoutUser() {
        dataManager.deactivateAllUsers()
        isLogged = false
        authenticationViewModel.stopTokenValidation()
    }

    @MainActor
    private func loadUserData() async {
        if dataManager.safeActiveUser() != nil {
            isLogged = true
        } else {
            do {
                let newUser = try await authenticationViewModel.getUser()
                dataManager.saveUser(newUser)
                isLogged = true
            } catch {
                isLogged = false
            }
        }
    }
}
