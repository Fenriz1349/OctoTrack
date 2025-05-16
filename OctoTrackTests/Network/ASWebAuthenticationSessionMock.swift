//
//  ASWebAuthenticationSessionMock.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 09/05/2025.
//

import AuthenticationServices
@testable import OctoTrack

class ASWebAuthenticationSessionMock: ASWebAuthenticationSession {
    var startCallCount = 0
    var completionHandler: ((URL?, Error?) -> Void)?
    var expectedURL: URL?
    var expectedCallbackURLScheme: String?

    override init(url: URL, callbackURLScheme: String?, completionHandler: @escaping (URL?, Error?) -> Void) {
        self.expectedURL = url
        self.expectedCallbackURLScheme = callbackURLScheme
        self.completionHandler = completionHandler
        super.init(url: url, callbackURLScheme: callbackURLScheme, completionHandler: completionHandler)
    }

    override func start() -> Bool {
        startCallCount += 1
        return true
    }

    func simulateCallback(url: URL) {
        completionHandler?(url, nil)
    }

    func simulateError(error: Error) {
        completionHandler?(nil, error)
    }
}

func makeSUTAuthenticator() -> (sut: GitHubAuthenticator, client: HTTPClientStub,
                                tokenManager: TokenAuthManager, keychain: KeychainServiceSpy) {
    let keychainMock = KeychainServiceSpy()
    let tokenManager = TokenAuthManager(keychain: keychainMock)
    let client = HTTPClientStub(result: .success((Data(), anyHTTPURLResponse())))

    let authenticator = GitHubAuthenticator(
        client: client,
        tokenAuthManager: tokenManager
    )

    return (authenticator, client, tokenManager, keychainMock)
}
