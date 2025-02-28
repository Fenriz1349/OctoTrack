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
    
    static func authorizeURL() -> URL {
           let baseURL = "https://github.com/login/oauth/authorize"
           var components = URLComponents(string: baseURL)!
           
           components.queryItems = [
               URLQueryItem(name: "client_id", value: config.clientID),
               URLQueryItem(name: "redirect_uri", value: config.redirectURI),
               URLQueryItem(name: "scope", value: config.scopeString)
           ]
           
           return components.url!
       }
    
    static func tokenExchangeRequest(with code: String) -> URLRequest {
        let baseURL = URL(string: "https://github.com/login/oauth/access_token")!
        
        let params = [
            "client_id": config.clientID,
            "client_secret": config.clientSecret,
            "code": code,
            "redirect_uri": config.redirectURI
        ]
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        
        let formBody = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = formBody.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    static func userInfoRequest(with token: String) -> URLRequest {
           let baseURL = URL(string: "https://api.github.com/user")!
           
           var request = URLRequest(url: baseURL)
           request.httpMethod = "GET"
           request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
           
           return request
       }
    
    static func privateReposRequest(with token: String) -> URLRequest {
           let baseURL = URL(string: "https://api.github.com/user/repos?visibility=private")!
           
           var request = URLRequest(url: baseURL)
           request.httpMethod = "GET"
           request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
           
           return request
       }
}
