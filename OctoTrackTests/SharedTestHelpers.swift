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

// MARK: - Repository Test Data

let testRepoId = 12345
let testRepoName = "test-repo"
let testRepoDescription = "A test repository"
let testRepoLanguage = "Swift"

let testRepoJSON: [String: Any] = [
    "id": testRepoId,
    "name": testRepoName,
    "description": testRepoDescription,
    "private": false,
    "owner": [
        "id": 1,
        "login": "octocat",
        "avatar_url": "https://github.com/images/avatar.jpg"
    ],
    "created_at": "2024-06-06T10:30:00Z",
    "updated_at": "2024-06-06T11:30:00Z",
    "language": testRepoLanguage
]

func makeRepositoryResponse() -> (model: Repository, json: Data) {
    let owner = makeOwner()
    let model = Repository(
        id: testRepoId,
        name: testRepoName,
        repoDescription: testRepoDescription,
        isPrivate: false,
        owner: owner,
        createdAt: Date(),
        updatedAt: Date(),
        language: testRepoLanguage,
        priority: .low
    )

    return (model, try! JSONSerialization.data(withJSONObject: testRepoJSON))
}
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
    return URL(string:
                "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&scope=repo%20user")!
}

func makeAuthCallbackURL() -> URL {
    return URL(string: "octotrack://callback?code=\(code)")!
}

func makeTokenAuthManager() -> TokenAuthManager {
    return TokenAuthManager(keychain: KeychainServiceSpy())
}

func makeExpiredTokenData() throws -> Data {
    let expiredDate = Date().addingTimeInterval(-8 * 24 * 60 * 60)
    let tokenData = TokenData(token: makeAccessToken(), creationDate: expiredDate)
    return try TokenMapper.encodeToken(tokenData)
}

func makeValidTokenData() throws -> Data {
    let tokenData = TokenData(token: makeAccessToken(), creationDate: Date())
    return try TokenMapper.encodeToken(tokenData)
}

func makeInvalidCallbackURL() -> URL {
    return URL(string: "octotrack://callback?error=access_denied")!
}

// MARK: - PullRequest Test Data

let testPRId = 67890
let testPRNumber = 42
let testPRTitle = "Fix issue with authentication"
let testPRBody = "This PR fixes the authentication bug"

let testPRJSON: [String: Any] = [
    "id": testPRId,
    "number": testPRNumber,
    "title": testPRTitle,
    "body": testPRBody,
    "draft": false,
    "created_at": "2024-06-06T09:00:00Z",
    "updated_at": "2024-06-06T10:00:00Z",
    "closed_at": NSNull(),
    "merged_at": NSNull()
]

func makePullRequestResponse() -> (model: PullRequest, json: Data) {
    let model = PullRequest(
        id: testPRId,
        number: testPRNumber,
        body: testPRBody,
        title: testPRTitle,
        createdAt: Date(),
        updateAt: Date(),
        closedAt: nil,
        mergedAt: nil,
        isDraft: false
    )

    return (model, try! JSONSerialization.data(withJSONObject: testPRJSON))
}

func makePullRequestListResponse() -> (model: [PullRequest], json: Data) {
    let (singlePR, _) = makePullRequestResponse()
    let models = [singlePR]
    let jsonArray = [testPRJSON]

    return (models, try! JSONSerialization.data(withJSONObject: jsonArray))
}

// MARK: - ViewModel Test Helpers

@MainActor
func makeAuthenticationViewModel() -> AuthenticationViewModel {
    return AuthenticationViewModel(
        onLoginSucceed: { _ in },
        onLogoutCompleted: { }
    )
}

@MainActor
func makeAppViewModel() -> AppViewModel {
    let (dataManager, _) = UserDataManagerTestHelpers.createUserDataManager()
    return AppViewModel(dataManager: dataManager)
}

@MainActor
func makeAccountViewModel() -> AccountViewModel {
    let (dataManager, _) = UserDataManagerTestHelpers.createUserDataManager()
    let authViewModel = makeAuthenticationViewModel()
    let viewModelFactory = ViewModelFactory(dataManager: dataManager)
    return AccountViewModel(
        dataManager: dataManager,
        authenticationViewModel: authViewModel,
        viewModelFactory: viewModelFactory
    )
}

@MainActor
func makeRepoListViewModel() -> RepoListViewModel {
    let (dataManager, _) = UserDataManagerTestHelpers.createUserDataManager()
    let viewModelFactory = ViewModelFactory(dataManager: dataManager)
    return RepoListViewModel(dataManager: dataManager, viewModelFactory: viewModelFactory)
}

@MainActor
func makeRepoDetailsViewModel() -> RepoDetailsViewModel {
    let (dataManager, _) = UserDataManagerTestHelpers.createUserDataManager()
    let testRepo = makeTestRepository()
    return RepoDetailsViewModel(repository: testRepo, dataManager: dataManager)
}

@MainActor
func makeAddRepoViewModel() -> AddRepoViewModel {
    let (dataManager, _) = UserDataManagerTestHelpers.createUserDataManager()
    return AddRepoViewModel(dataManager: dataManager)
}

func makeUserHeaderViewModel() -> UserHeaderViewModel {
    let testUser = makeUser().model
    return UserHeaderViewModel(user: testUser, repoCount: 3)
}
