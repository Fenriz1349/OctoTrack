//
//  EndpointBuildeTest.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/03/2025.
//

import XCTest
@testable import OctoTrack

final class EndpointBuilderTests: XCTestCase {

    // MARK: - Generic buildRequest Tests

    func test_buildRequest_addsQueryItemsToURL() throws {
        let request = try EndpointBuilder.authorize(
            clientID: clientID,
            redirectURI: redirectURI,
            scopes: scopes
        ).buildRequest()

        let urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems

        XCTAssertNotNil(queryItems)
        XCTAssertEqual(queryItems?.count, 3)

        XCTAssertEqual(queryItems?.first(where: { $0.name == "client_id" })?.value, clientID)
        XCTAssertEqual(queryItems?.first(where: { $0.name == "redirect_uri" })?.value, redirectURI)
        XCTAssertEqual(queryItems?.first(where: { $0.name == "scope" })?.value, "repo user")
    }

    func test_buildRequest_withNilQueryItems_doesNotAddQueryItemsToURL() throws {
        let request = try EndpointBuilder.user(token: token).buildRequest()

        let urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems

        XCTAssertNil(queryItems)
    }

    // MARK: - User Endpoint Tests

    func test_user_buildsCorrectRequest() throws {
        let request = try EndpointBuilder.user(token: token).buildRequest()

        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api.github.com")
        XCTAssertEqual(request.url?.path, "/user")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/vnd.github.v3+json")
    }

    // MARK: - Repo Endpoint Tests

    func test_repo_buildsCorrectRequestWithToken() throws {
        let request = try EndpointBuilder.repo(owner: owner, name: name, token: token).buildRequest()

        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api.github.com")
        XCTAssertEqual(request.url?.path, "/repos/\(owner)/\(name)")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/vnd.github.v3+json")
    }

    func test_repo_buildsCorrectRequestWithoutToken() throws {
        let request = try EndpointBuilder.repo(owner: owner, name: name, token: nil).buildRequest()

        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api.github.com")
        XCTAssertEqual(request.url?.path, "/repos/\(owner)/\(name)")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.value(forHTTPHeaderField: "Authorization"))
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/vnd.github.v3+json")
    }

    // MARK: - Authorize Endpoint Tests

    func test_authorize_buildsCorrectRequest() throws {
        let request = try EndpointBuilder.authorize(clientID: clientID,
                                                    redirectURI: redirectURI, scopes: scopes).buildRequest()

        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "github.com")
        XCTAssertEqual(request.url?.path, "/login/oauth/authorize")
        XCTAssertEqual(request.httpMethod, "GET")

        let urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems

        XCTAssertEqual(queryItems?.first(where: { $0.name == "client_id" })?.value, clientID)
        XCTAssertEqual(queryItems?.first(where: { $0.name == "redirect_uri" })?.value, redirectURI)
        XCTAssertEqual(queryItems?.first(where: { $0.name == "scope" })?.value, "repo user")
    }

    // MARK: - Exchange Token Endpoint Tests

    func test_exchangeToken_buildsCorrectRequest() throws {
        let request = try EndpointBuilder.exchangeToken(
            code: code,
            clientID: clientID,
            clientSecret: clientSecret,
            redirectURI: redirectURI
        ).buildRequest()

        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "github.com")
        XCTAssertEqual(request.url?.path, "/login/oauth/access_token")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")

        if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            XCTAssertTrue(bodyString.contains("client_id=\(clientID)"))
            XCTAssertTrue(bodyString.contains("client_secret=\(clientSecret)"))
            XCTAssertTrue(bodyString.contains("code=\(code)"))
            XCTAssertTrue(bodyString.contains("redirect_uri=\(redirectURI)"))
        }
    }
}
