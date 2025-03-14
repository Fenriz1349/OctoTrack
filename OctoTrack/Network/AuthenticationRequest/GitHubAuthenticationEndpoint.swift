//
//  AuthenticationEndpoint.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation
import Security
import WebKit
import AuthenticationServices

enum GitHubAuthenticationEndpoint {

    struct GitHubOAuthConfig {
        let clientID: String
        let clientSecret: String
        let redirectURI: String
        let scopes: [String]

        var scopeString: String {
            return scopes.joined(separator: " ")
        }
    }

    static let config = GitHubOAuthConfig(
        clientID: "Ov23liEj4By3dirrDHjy",
        clientSecret: "927c76c322611c89e69d19c742cc62d099ef1836",
        redirectURI: "octotrack://callback",
        scopes: ["repo", "user"]
    )

    static func authorizeURL() throws -> URL {
        let request = try EndpointBuilder.authorize(
            clientID: config.clientID,
            redirectURI: config.redirectURI,
            scopes: config.scopes
        ).buildRequest()

        guard let url = request.url else {
            throw Errors.invalidURL
        }

        return url
    }

    static func tokenExchangeRequest(with code: String) throws -> URLRequest {
        return try EndpointBuilder.exchangeToken(
            code: code,
            clientID: config.clientID,
            clientSecret: config.clientSecret,
            redirectURI: config.redirectURI
        ).buildRequest()
    }
}
