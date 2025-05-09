//
//  SharedTestHelpers.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/03/2025.
//

import XCTest
@testable import OctoTrack

let owner = "octocat"
let name = "hello-world"
let token = "test-token"
let clientID = "client-id"
let clientSecret = "client-secret"
let redirectURI = "octotrack://callback"
let scopes = ["repo", "user"]
let code = "auth-code"
let testToken = "test-token"
let testCode = "test-authorization-code"

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func anyURLRequest() -> URLRequest {
    URLRequest(url: anyURL())
}

func anyData() -> Data {
    "any data".data(using: .utf8)!
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyHTTPURLResponse(statusCode: Int = 200) -> HTTPURLResponse {
    HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func makeUser() -> (model: User, json: [String: Any]) {
    let model = User(id: 1, login: "octocat", avatarURL: "https://github.com/images/avatar.jpg", repoList: [])

    let json: [String: Any] = [
        "id": model.id,
        "login": model.login,
        "avatar_url": model.avatarURL
    ]

    return (model, json)
}

func makeOwner() -> Owner {
    return Owner(id: 1, login: "octocat", avatarURL: "https://github.com/images/avatar.jpg")
}

func makeUserJSON(_ json: [String: Any]) throws -> Data {
    return try JSONSerialization.data(withJSONObject: json)
}

func makeSUTUSer(result: Result<(Data, HTTPURLResponse),
                 Error> = .success((Data(), anyHTTPURLResponse()))) -> (UserLoader, HTTPClientStub) {
    let client = HTTPClientStub(result: result)
    let sut = UserLoader(client: client)
    return (sut, client)
}

func makeTestRepository() -> Repository {
    Repository(
        id: 12345,
        name: "test-repo",
        repoDescription: nil,
        isPrivate: false,
        owner: makeOwner(),
        createdAt: Date(),
        updatedAt: nil,
        language: "Swift",
        priority: .low
    )
}

// MARK: - Authentication Test Helpers

func makeAccessToken() -> String {
    return "gho_mockAccessToken12345"
}

func makeTokenResponse() -> ([String: Any], Data) {
    let json = ["access_token": makeAccessToken(), "token_type": "bearer", "scope": "repo,user"]
    let data = try! JSONSerialization.data(withJSONObject: json)
    return (json, data)
}

func makeAuthURL() -> URL {
    return URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&scope=repo%20user")!
}

func makeAuthCallbackURL() -> URL {
    return URL(string: "octotrack://callback?code=\(code)")!
}

func makeTokenAuthManager() -> TokenAuthManager {
    return TokenAuthManager(keychain: KeychainServiceSpy())
}
