//
//  AuthenticationViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import Foundation

@Observable final class AuthenticationViewModel {

    var isAuthenticating: Bool = false
    var authError: Error?
    private let authenticator = GitHubAuthenticator()
    private let keychain = KeychainService()
    let onLoginSucceed: (User) -> Void
    let onLogoutCompleted: () -> Void

    var isAuthenticated: Bool {
           return authenticator.isAuthenticated
       }

    init(onLoginSucceed: @escaping (User) -> Void, onLogoutCompleted: @escaping () -> Void) {
            self.onLoginSucceed = onLoginSucceed
            self.onLogoutCompleted = onLogoutCompleted
        }

    @MainActor
    func login() async throws {
        guard !isAuthenticating else { return }

        isAuthenticating = true
        authError = nil

        Task {
            do {
                try await authenticator.authenticate()
                self.isAuthenticating = false
                try await onLoginSucceed(getUser())
            } catch {
                self.authError = error
                self.isAuthenticating = false
            }
        }
    }

    func signOut() {
        do {
            try authenticator.signOut()
            onLogoutCompleted()
        } catch {
            authError = error
        }
    }

    func getUser() async throws -> User {
        let token = try  await authenticator.authenticate()
        let userRequest: UserLoader = UserLoader()
        let request = try UserEndpoint.userInfoRequest(with: token)
        do {
            return try await userRequest.userLoader(from: request)
        } catch {
            throw error
        }
    }
}
