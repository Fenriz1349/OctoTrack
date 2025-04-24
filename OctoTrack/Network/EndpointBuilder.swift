//
//  EndpointBuilder.swift
//  OctoTrack
//
//  Created by Julien Cotte on 07/03/2025.
//

import Foundation

/// EndpointBuilder sert à générer uniquement tous les élements qui composeront la requete SQL
/// Pour chaque cas on peut personalisé l'url, le header et ou le body
enum EndpointBuilder {
    case user(token: String)
    case repo(owner: String, repoName: String, token: String?)
    case allPullRequests(owner: String, repoName: String, token: String?)
    case pullRequest(owner: String, repoName: String, number: Int, token: String?)
    case authorize(clientID: String, redirectURI: String, scopes: [String])
    case exchangeToken(code: String, clientID: String, clientSecret: String, redirectURI: String)

    private var baseURL: URL {
        switch self {
        case .user, .repo, .allPullRequests, .pullRequest:
            return URL(string: "https://api.github.com")!
        case .authorize, .exchangeToken:
            return URL(string: "https://github.com")!
        }
    }

    private var path: String {
        switch self {
        case .user:  "/user"
        case .repo(let owner, let name, _): "/repos/\(owner)/\(name)"
        case .allPullRequests(let owner, let repo, _): "/repos/\(owner)/\(repo)/pulls"
        case .pullRequest(let owner, let repo, let number, _): "/repos/\(owner)/\(repo)/pulls/\(number)"
        case .authorize:  "/login/oauth/authorize"
        case .exchangeToken:  "/login/oauth/access_token"
        }
    }

    private var httpMethod: String {
        switch self {
        case .exchangeToken:  "POST"
        case .user, .repo, .authorize, .allPullRequests, .pullRequest:  "GET"
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
        case .user, .repo, .exchangeToken, .allPullRequests, .pullRequest:
            return nil
        }
    }

    private var httpBody: Data? {
        switch self {
        case .user, .repo, .allPullRequests, .pullRequest, .authorize: return nil
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
        case .repo(_, _, let token), .allPullRequests(_, _, let token), .pullRequest(_, _, _, let token):
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

    func buildRequest() throws -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.path = path
        urlComponents?.queryItems = queryItems

        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = httpMethod
        request.httpBody = httpBody

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
