//
//  AuthenticationViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import Foundation

@Observable final class AuthenticationViewModel {

    var username: String = "Fenriz1349"
    var password: String = ""

    private let authenticator: Authenticator
    private let keychain = KeychainStore()
    let onLoginSucceed: (User) -> Void

    init(authenticator: Authenticator = Authenticator(),
         _ callback: @escaping (User) -> Void) {
        self.authenticator = authenticator
        self.onLoginSucceed = callback
    }

    func login() async throws {
        do {
            //            let request = try AuthenticationEndpoint.request(with: username, and: password)
            //            let token = try await authenticator.requestToken(from: request)
            //            if let data = token.data(using: .utf8) {
            //                try keychain.delete(key: username)
            //                try keychain.insert(key: username, data: data)
            try await onLoginSucceed(getUser())
        }
        catch {
            print(error)
            throw error
        }
    }
    
    func getUser() async throws -> User{
        do {
            let userRequest: UserLoader = UserLoader()
            let request = try UserEndpoint.request(with: username)
            let user = try await userRequest.userLoader(from: request)

            return User(id: user.id, login: user.login, avatarURL: user.avatarURL, repoList: user.repoList)
        } catch {
            print(error)
            throw error
        }
    }
}
