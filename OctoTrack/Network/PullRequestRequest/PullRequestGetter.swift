//
//  PullRequestGetter.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import Foundation

final class PullRequestGetter {

    private let client: HTTPClient

    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }

    func allPullRequestsGetter(from request: URLRequest) async throws -> [PullRequest] {
        let (data, response) = try await client.request(from: request)
        let pullRequests =  try PullRequestMapper.mapList(data, and: response)

        return pullRequests
    }

    func pullRequestGetter(from request: URLRequest) async throws -> PullRequest {
        let (data, response) = try await client.request(from: request)
        let pullRequest =  try PullRequestMapper.map(data, and: response)

        return pullRequest
    }
}
