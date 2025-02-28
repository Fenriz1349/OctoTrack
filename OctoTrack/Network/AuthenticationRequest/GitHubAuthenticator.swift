//
//  Authenticator.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation
import AuthenticationServices

final class GitHubAuthenticator: NSObject {
    
    private enum Constants {
        static let tokenKey = "github.access.token"
    }
    private let client = URLSessionHTTPClient()
    private let keychainService = KeychainService()
    private var webAuthSession: ASWebAuthenticationSession?
    
    var isAuthenticated: Bool {
        do {
            let _ = try retrieveToken()
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
            let authURL = GitHubAuthenticationEndpoint.authorizeURL()
            let callbackScheme = URL(string: GitHubAuthenticationEndpoint.config.redirectURI)?.scheme ?? ""
            
            webAuthSession = ASWebAuthenticationSession (
                url: authURL,
                callbackURLScheme: callbackScheme
            ) { [weak self] callbackURL, error in
                guard let self = self else {
                    continuation.resume(throwing: Errors.authenticationFailed)
                    return
                }
                
                if let error = error {
                    print("❌ Erreur ASWebAuthenticationSession: \(error.localizedDescription)")
                    let nsError = error as NSError
                    if nsError.domain == ASWebAuthenticationSessionErrorDomain,
                       nsError.code == ASWebAuthenticationSessionError.canceledLogin.rawValue {
                        continuation.resume(throwing: Errors.authenticationCancelled)
                    } else {
                        continuation.resume(throwing: error)
                    }
                    return
                }
                
                guard let callbackURL = callbackURL else {
                    print("✅ URL de callback reçue: \(callbackURL)")
                    continuation.resume(throwing: Errors.authenticationFailed)
                    return
                }
                
                Task {
                    do {
                        let token = try await self.handleCallback(url: callbackURL)
                        continuation.resume(returning: token)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            webAuthSession?.presentationContextProvider = self
            webAuthSession?.prefersEphemeralWebBrowserSession = true
            webAuthSession?.start()
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
        let tokenRequest = GitHubAuthenticationEndpoint.tokenExchangeRequest(with: code)
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
    
    private func storeToken(_ token: String) throws {
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
                for window in windowScene.windows {
                    if window.isKeyWindow {
                        return window
                    }
                }
            }
        }
        return UIWindow()
    }
}
