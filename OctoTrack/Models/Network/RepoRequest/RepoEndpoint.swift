//
//  RepoEndpoint.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import Foundation

enum RepoEndpoint {
    static func request(owner: String, repoName: String) throws -> URLRequest {
        let baseURL = URL(string: "https://api.github.com/repos/\(owner)/\(repoName)")!
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
