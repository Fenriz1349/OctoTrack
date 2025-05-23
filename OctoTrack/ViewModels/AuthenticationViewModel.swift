//
//  AuthenticationViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import Foundation

@Observable final class AuthenticationViewModel {

    enum Feedback: FeedbackHandler, Equatable {
        case none
        case authFailed(error: String)

        var message: String? {
            switch self {
            case .none: return nil
            case .authFailed(let error): return String(localized: "authFail \(error)")
            }
        }

        var isError: Bool { true }
    }

    var isAuthenticating: Bool = false
    var feedback: Feedback = .none
    private let authenticator = GitHubAuthenticator()
    private let tokenValidator = TokenValidator()
    let onLoginSucceed: (User) -> Void
    let onLogoutCompleted: () -> Void

    var authenticationState: AuthenticationState {
            authenticator.authenticationState
        }

    init(onLoginSucceed: @escaping (User) -> Void, onLogoutCompleted: @escaping () -> Void) {
            self.onLoginSucceed = onLoginSucceed
            self.onLogoutCompleted = onLogoutCompleted
        }

    @MainActor
    func login() async throws {
        guard !isAuthenticating else { return }
        isAuthenticating = true

        Task {
            do {
                try await authenticator.authenticate()
                isAuthenticating = false
                try await onLoginSucceed(getUser())
            } catch {
                feedback = .authFailed(error: error.localizedDescription)
                isAuthenticating = false
            }
        }
    }

    func isTokenValid() async -> Bool {
        return await authenticator.isTokenValid()
    }

    func refreshToken() throws {
        try authenticator.refreshToken()
    }

    func signOut() {
        do {
            try authenticator.signOut()
            stopTokenValidation()
            onLogoutCompleted()
        } catch {
            feedback = .authFailed(error: error.localizedDescription)
        }
    }

    func getUser() async throws -> User {
        let token = try  await authenticator.retrieveToken()
        let userRequest: UserLoader = UserLoader()
        let request = try UserEndpoint.userInfoRequest(with: token)
        return try await userRequest.userLoader(from: request)
    }

    func startTokenValidation() {
        tokenValidator.startPeriodicValidation { [weak self] in
            guard let self = self else { return }
            if self.authenticator.authenticationState == .expired,
               await self.isTokenValid() {
                try? self.refreshToken()
            }
        }
    }

    func stopTokenValidation() {
        tokenValidator.stopPeriodicValidation()
    }
}
