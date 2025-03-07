//
//  EndpointBuilder.swift
//  OctoTrack
//
//  Created by Julien Cotte on 07/03/2025.
//

import Foundation

enum EndpointBuilder {
    case user(token: String)
    case repo(owner: String, name: String, token: String?)
    case authorize(clientID: String, redirectURI: String, scopes: [String])
    case exchangeToken(code: String, clientID: String, clientSecret: String, redirectURI: String)

    private var baseURL: URL {
        switch self {
        case .user, .repo:
            return URL(string: "https://api.github.com")!
        case .authorize, .exchangeToken:
            return URL(string: "https://github.com")!
        }
    }

    private var path: String {
        switch self {
        case .user: return "/user"
        case .repo(let owner, let name, _): return "/repos/\(owner)/\(name)"
        case .authorize: return "/login/oauth/authorize"
        case .exchangeToken: return "/login/oauth/access_token"
        }
    }

    private var httpMethod: String {
        switch self {
        case .exchangeToken: return "POST"
        case .user, .repo, .authorize: return "GET"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case .authorize(let clientID, let redirectURI, let scopes):
            return [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "redirect_uri", value: redirectURI),
                URLQueryItem(name: "scope", value: scopes.joined(separator: " "))
            ]
        case .user, .repo, .exchangeToken:
            return nil
        }
    }

    private var httpBody: Data? {
        switch self {
        case .user, .repo, .authorize: return nil
        case .exchangeToken(let code, let clientID, let clientSecret, let redirectURI):
            let params = [
                "client_id": clientID,
                "client_secret": clientSecret,
                "code": code,
                "redirect_uri": redirectURI
            ]
            let formBody = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            return formBody.data(using: .utf8)
        }
    }

    private var headers: [String: String]? {
        var customHeaders: [String: String] = [:]
        switch self {
        case .user(let token):
            customHeaders["Accept"] = "application/vnd.github.v3+json"
            customHeaders["Authorization"] = "Bearer \(token)"
        case .repo(_, _, let token):
            customHeaders["Accept"] = "application/vnd.github.v3+json"
            if let token = token {
                customHeaders["Authorization"] = "Bearer \(token)"
            }
        case .authorize:
            customHeaders["Accept"] = "application/json"
        case .exchangeToken:
            customHeaders["Accept"] = "application/json"
            customHeaders["Content-Type"] = "application/x-www-form-urlencoded"
        }
        return customHeaders
    }

    func buildRequest() -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.path = path
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else {
            fatalError("Impossible de construire l'URL avec les composants fournis")
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
