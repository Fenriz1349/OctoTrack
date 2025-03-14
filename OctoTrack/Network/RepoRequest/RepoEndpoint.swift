//
//  RepoEndpoint.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import Foundation

enum RepoEndpoint {
    static func request(owner: String, repoName: String, token: String? = nil) throws -> URLRequest {
        return try EndpointBuilder.repo(owner: owner, name: repoName, token: token).buildRequest()
    }
}
