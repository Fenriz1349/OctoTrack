//
//  Authenticator.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation
import AuthenticationServices

protocol GitHubAuthenticatorProtocol {
    var isAuthenticated: Bool { get }
    func authenticate() async throws -> String
    func signOut() throws
}

typealias AuthenticationCompletionHandler = (Result<String, Error>) -> Void

final class GitHubAuthenticator: NSObject, GitHubAuthenticatorProtocol {

    private enum Constants {
        static let tokenKey = "github.access.token"
    }
    private let client = URLSessionHTTPClient()
    private let keychainService = KeychainService()
    private var webAuthSession: ASWebAuthenticationSession?
    private var completionHandler: AuthenticationCompletionHandler?

    var isAuthenticated: Bool {
        do {
             _ = try retrieveToken()
            return true
        } catch {
            return false
        }
    }

    func authenticate() async throws -> String {
        if let token = try? retrieveToken() {
            return token
        }

        return try await startAuthenticationFlow()
    }

    func signOut() throws {
        try keychainService.delete(key: Constants.tokenKey)
    }

    // MARK: - Private

    private func startAuthenticationFlow() async throws -> String {
         return try await withCheckedThrowingContinuation { continuation in
             startWebAuthentication { result in
                 continuation.resume(with: result)
             }
         }
     }

    private func startWebAuthentication(completion: @escaping AuthenticationCompletionHandler) {
        self.completionHandler = completion

        do {
            let authURL = try GitHubAuthenticationEndpoint.authorizeURL()
            let callbackScheme = URL(string: GitHubAuthenticationEndpoint.config.redirectURI)?.scheme ?? ""

            webAuthSession = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: callbackScheme
            ) { [weak self] callbackURL, error in
                guard let self = self else { return }

                if let error = error {
                    self.completionHandler?(.failure(error))
                    return
                }

                guard let callbackURL = callbackURL else {
                    self.completionHandler?(.failure(Errors.authenticationFailed))
                    return
                }

                Task {
                    do {
                        let token = try await self.handleCallback(url: callbackURL)
                        self.completionHandler?(.success(token))
                    } catch {
                        self.completionHandler?(.failure(error))
                    }
                }
            }

            webAuthSession?.presentationContextProvider = self
            webAuthSession?.prefersEphemeralWebBrowserSession = true
            webAuthSession?.start()
        } catch {
            completionHandler?(.failure(error))
        }
    }

    private func handleCallback(url: URL) async throws -> String {
        print("Callback URL reçue: \(url)")

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print("Impossible de créer les composants URL")
            throw Errors.authenticationFailed
        }

        print("Composants URL: \(components)")
        print("Query items: \(String(describing: components.queryItems))")

        guard let queryItems = components.queryItems,
              let codeItem = queryItems.first(where: { $0.name == "code" }),
              let code = codeItem.value else {
            print("Code d'autorisation manquant")
            throw Errors.missingAuthorizationCode
        }

        print("Code d'autorisation obtenu: \(code)")

        // Échange code -> token
        let tokenRequest = try GitHubAuthenticationEndpoint.tokenExchangeRequest(with: code)
        print("Requête de token préparée")

        do {
            let token = try await requestToken(from: tokenRequest)
            print("Token obtenu avec succès")

            try storeToken(token)
            print("Token stocké dans le keychain")

            return token
        } catch {
            print("Erreur lors de l'échange du token: \(error)")
            throw error
        }
    }

    @MainActor
    private func requestToken(from request: URLRequest) async throws -> String {
           let (data, response) = try await client.request(from: request)
           let token = try GitHubAuthenticationMapper.map(data, and: response)

           return token
       }

    func storeToken(_ token: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw Errors.tokenExchangeFailed
        }
        try keychainService.insert(key: Constants.tokenKey, data: data)
    }

    private func retrieveToken() throws -> String {
        let data = try keychainService.retrieve(key: Constants.tokenKey)
        guard let token = String(data: data, encoding: .utf8) else {
            throw Errors.noStoredToken
        }
        return token
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding

extension GitHubAuthenticator: ASWebAuthenticationPresentationContextProviding {
    @MainActor
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                for window in windowScene.windows where window.isKeyWindow {
                    return window
                }
            }
        }
        return UIWindow()
    }
}
