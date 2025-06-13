//
//  PullRequestEndpoint.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import Foundation

enum PullRequestEndpoint {
    static func request(owner: String,
                        repoName: String,
                        token: String? = nil,
                        state: String = "all") throws -> URLRequest {
           return try EndpointBuilder.allPullRequests(owner: owner,
                                                      repoName: repoName,
                                                      token: token,
                                                      state: state).buildRequest()
       }
}
