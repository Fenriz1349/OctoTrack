//
//  Authenticator.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation
import AuthenticationServices

enum AuthenticationState {
    case unauthenticated
    case authenticated
    case expired
}

protocol GitHubAuthenticatorProtocol {
    var authenticationState: AuthenticationState { get }
    func authenticate() async throws
    func retrieveToken() async throws -> String
    func signOut() throws
}

typealias AuthenticationCompletionHandler = (Result<Void, Error>) -> Void

final class GitHubAuthenticator: NSObject, GitHubAuthenticatorProtocol {

    private enum Constants {
        static let tokenKey = "github.access.token"
    }
    private let client = URLSessionHTTPClient()
    private let tokenAuthManager = TokenAuthManager()
    private var webAuthSession: ASWebAuthenticationSession?
    private var completionHandler: AuthenticationCompletionHandler?

    var authenticationState: AuthenticationState {
        if tokenAuthManager.isTokenExpired() {
            return .expired
        }
        return tokenAuthManager.isAuthenticated ? .authenticated : .unauthenticated
    }

    func authenticate() async throws {
           switch authenticationState {
           case .authenticated:
               return
           case .expired, .unauthenticated:
               try await startAuthenticationFlow()
           }
       }

    func signOut() throws {
        try tokenAuthManager.deleteToken()
    }

    private func startAuthenticationFlow() async throws {
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
                        try await self.handleCallback(url: callbackURL)
                        self.completionHandler?(.success(()))
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

    private func handleCallback(url: URL) async throws {

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw Errors.authenticationFailed
        }

        guard let queryItems = components.queryItems,
              let codeItem = queryItems.first(where: { $0.name == "code" }),
              let code = codeItem.value else {
            throw Errors.missingAuthorizationCode
        }

        let tokenRequest = try GitHubAuthenticationEndpoint.tokenExchangeRequest(with: code)

        do {
            let token = try await requestToken(from: tokenRequest)

            try tokenAuthManager.storeToken(token)

        } catch {
            throw error
        }
    }

    func retrieveToken() async throws -> String {
            switch authenticationState {
            case .authenticated:
                return try tokenAuthManager.retrieveToken()
            case .expired:
                try await startAuthenticationFlow()
                return try tokenAuthManager.retrieveToken()
            case .unauthenticated:
                try await startAuthenticationFlow()
                return try tokenAuthManager.retrieveToken()
            }
        }

    @MainActor
    private func requestToken(from request: URLRequest) async throws -> String {
           let (data, response) = try await client.request(from: request)
           let token = try GitHubAuthenticationMapper.map(data, and: response)

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
