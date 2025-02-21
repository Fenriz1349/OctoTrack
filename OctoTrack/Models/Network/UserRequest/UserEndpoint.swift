//
//  UserEndpoint.swift
//  OctoTrack
//
//  Created by Julien Cotte on 17/02/2025.
//

import Foundation

enum UserEndpoint {
    static func request(with username: String) throws -> URLRequest {
        let baseURL = URL(string: "https://api.github.com/users/\(username)")!
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
