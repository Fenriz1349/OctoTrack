//
//  GitHubAuthenticationEndpointTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 09/05/2025.
//

import XCTest
@testable import OctoTrack

final class GitHubAuthenticationEndpointTests: XCTestCase {
    
    func test_config_hasCorrectValues() {
        // Given
        let config = GitHubAuthenticationEndpoint.config
        
        // Then
        XCTAssertEqual(config.clientID, "Ov23liEj4By3dirrDHjy")
        XCTAssertEqual(config.clientSecret, "927c76c322611c89e69d19c742cc62d099ef1836")
        XCTAssertEqual(config.redirectURI, "octotrack://callback")
        XCTAssertEqual(config.scopes, ["repo", "user"])
        XCTAssertEqual(config.scopeString, "repo user")
    }
    
    func test_authorizeURL_buildsCorrectURL() throws {
        // When
        let url = try GitHubAuthenticationEndpoint.authorizeURL()
        
        // Then
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "github.com")
        XCTAssertEqual(url.path, "/login/oauth/authorize")
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems
        
        XCTAssertEqual(queryItems?.first(where: { $0.name == "client_id" })?.value, GitHubAuthenticationEndpoint.config.clientID)
        XCTAssertEqual(queryItems?.first(where: { $0.name == "redirect_uri" })?.value, GitHubAuthenticationEndpoint.config.redirectURI)
        XCTAssertEqual(queryItems?.first(where: { $0.name == "scope" })?.value, "repo user")
    }
    
    func test_tokenExchangeRequest_buildsCorrectRequest() throws {
        // When
        let request = try GitHubAuthenticationEndpoint.tokenExchangeRequest(with: testCode)
        
        // Then
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "github.com")
        XCTAssertEqual(request.url?.path, "/login/oauth/access_token")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
        
        if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            XCTAssertTrue(bodyString.contains("client_id=\(GitHubAuthenticationEndpoint.config.clientID)"))
            XCTAssertTrue(bodyString.contains("client_secret=\(GitHubAuthenticationEndpoint.config.clientSecret)"))
            XCTAssertTrue(bodyString.contains("code=\(testCode)"))
            XCTAssertTrue(bodyString.contains("redirect_uri=\(GitHubAuthenticationEndpoint.config.redirectURI)"))
        } else {
        }
    }
}
