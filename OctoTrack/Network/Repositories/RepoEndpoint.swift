//
//  RepoEndpoint.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import Foundation

enum RepoEndpoint {
    static func allUserReposRequest(token: String) throws -> URLRequest {
          return try EndpointBuilder.allUserRepos(token: token).buildRequest()
      }

    static func request(owner: String, repoName: String, token: String? = nil) throws -> URLRequest {
        return try EndpointBuilder.repo(owner: owner, repoName: repoName, token: token).buildRequest()
    }
}
