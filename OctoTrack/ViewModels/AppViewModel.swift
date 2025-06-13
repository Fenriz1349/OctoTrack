//
//  AppVC.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import SwiftUI

@MainActor
@Observable final class AppViewModel {

    enum Feedback: FeedbackHandler, Equatable {
        case none
        case emptyRepo
        case resetSucessed
        case resetFailed(error: String)

        var message: String? {
            switch self {
            case .none: return nil
            case .emptyRepo: return String(localized: "emptyRepo")
            case .resetSucessed: return String(localized: "resetSuccess")
            case .resetFailed(let error): return String(localized: "resetFailed \(error)")
            }
        }

        var isError: Bool {
            switch self {
            case .resetSucessed: return false
            default: return true
            }
        }
    }

    var feedback: Feedback = .none
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
            if dataManager.activeUser != nil {
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

    func resetUserRepository() {
        do {
            try dataManager.resetAllRepositories()
            feedback = .resetSucessed
        } catch {
            feedback = .resetFailed(error: error.localizedDescription)
        }
    }

    func checkIfEmptyRepoList() -> Bool {
        if let currentUser = dataManager.activeUser, currentUser.repoList.isEmpty {
            feedback = .emptyRepo
            return false
        }
        return  true
    }
}
