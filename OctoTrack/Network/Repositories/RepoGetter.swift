//
//  RepoGetter.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import Foundation

final class RepoGetter {

    private let client: HTTPClient

    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }

    func repoGetter(from request: URLRequest) async throws -> Repository {
        let (data, response) = try await client.request(from: request)
        let repo =  try RepoMapper.map(data, and: response)

        return repo
    }

    func getAllUserRepos(from request: URLRequest) async throws -> [Repository] {
        let (data, response) = try await client.request(from: request)
        let repos = try RepoMapper.mapList(data, and: response)
        return repos
    }
}
