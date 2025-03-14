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
    let model = User(id: 1, login: "octocat", avatarURL: "https://github.com/images/avatar.jpg")

    let json: [String: Any] = [
        "id": model.id,
        "login": model.login,
        "avatar_url": model.avatarURL
    ]

    return (model, json)
}

func makeUserJSON(_ json: [String: Any]) throws -> Data {
    return try JSONSerialization.data(withJSONObject: json)
}

func makeSUTUSer(result: Result<(Data, HTTPURLResponse),
                 Error> = .success((Data(), anyHTTPURLResponse()))) -> (UserLoader, HTTPClientMock) {
    let client = HTTPClientMock(result: result)
    let sut = UserLoader(client: client)
    return (sut, client)
}

func makeTestRepository() -> Repository {
    Repository(
        id: 12345,
        name: "test-repo",
        isPrivate: false,
        avatar: AvatarProperties(name: "test-user", url: "https://example.com/avatar.jpg"),
        createdAt: Date(),
        language: ["Swift"]
    )
}
