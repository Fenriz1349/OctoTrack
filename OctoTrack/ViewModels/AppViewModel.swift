//
//  AppVC.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import SwiftUI

@MainActor
final class AppViewModel: ObservableObject {

    @Published var isLogged: Bool = false
    @Published var isInitializing: Bool = true
    @Published var authenticationViewModel: AuthenticationViewModel
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

            do {
                let authState = authenticationViewModel.authenticationState

                switch authState {
                case .authenticated:
                    await loadUserData()
                    if dataManager.activeUser != nil {
                        isLogged = true
                            authenticationViewModel.startTokenValidation()
                    } else {
                        isLogged = false
                    }
                case .expired:
                    if await authenticationViewModel.isTokenValid() {
                        try authenticationViewModel.refreshToken()
                        await loadUserData()
                            authenticationViewModel.startTokenValidation()
                    } else {
                        logoutUser()
                    }

                case .unauthenticated:
                    logoutUser()
                }
            } catch {
                logoutUser()
            }
        isInitializing = false
        }

    func loginUser(user: User) {
        self.isLogged = true
        dataManager.saveUser(user)
    }

    func logoutUser() {
        isLogged = false
        authenticationViewModel.stopTokenValidation()
        dataManager.deactivateAllUsers()
    }

    @MainActor
    private func loadUserData() async {
        if dataManager.activeUser != nil {
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
