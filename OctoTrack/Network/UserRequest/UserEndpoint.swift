//
//  UserEndpoint.swift
//  OctoTrack
//
//  Created by Julien Cotte on 17/02/2025.
//

import Foundation

enum UserEndpoint {
    static func request(with username: String) throws -> URLRequest {
        let baseURL = URL(string: "https://api.github.com/user/\(username)")!
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    static func userInfoRequest(with token: String) -> URLRequest {
           let baseURL = URL(string: "https://api.github.com/user")!
           
           var request = URLRequest(url: baseURL)
           request.httpMethod = "GET"
           request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
           
           return request
       }
}
