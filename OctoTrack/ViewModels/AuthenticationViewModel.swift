//
//  AuthenticationViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import Foundation

@Observable final class AuthenticationViewModel {
    
    private var token: String?
    var isAuthenticated: Bool = false
    var isAuthenticating: Bool = false
    var authError: Error?
    private let authenticator = GitHubAuthenticator()
    private let keychain = KeychainService()
    let onLoginSucceed: (User) -> Void
    
    
    init(_ callback: @escaping (User) -> Void) {
        self.isAuthenticated = authenticator.isAuthenticated
        self.onLoginSucceed = callback
    }
    
    @MainActor
    func login() async throws {
        guard !isAuthenticating else { return }
        
        isAuthenticating = true
        authError = nil
        
        Task {
            do {
                let token = try await authenticator.authenticate()
                self.token = token
                self.isAuthenticated = true
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
                token = nil
                isAuthenticated = false
            } catch {
                authError = error
            }
        }
    
    func checkAuthenticationStatus() {
        isAuthenticated = authenticator.isAuthenticated
        }
    
    func getUser() async throws -> User {
        guard let token = token else {
            throw Errors.missingToken
        }
        let userRequest: UserLoader = UserLoader()
        let request = UserEndpoint.userInfoRequest(with: token)
        do {
            return try await userRequest.userLoader(from: request)
        } catch {
            print(error)
            throw error
        }
    }
}
