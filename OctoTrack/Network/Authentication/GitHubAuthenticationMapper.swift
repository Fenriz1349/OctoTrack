//
//  AuthenticationMapper.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation

enum GitHubAuthenticationMapper {

    private struct Root: Decodable {
        let token: String
    }

    static func map(_ data: Data, and response: HTTPURLResponse) throws -> String {

        guard response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let accessToken = json["access_token"] as? String {
               return accessToken
           }

        if let responseString = String(data: data, encoding: .utf8) {
            let components = responseString.components(separatedBy: "&")
            for component in components {
                let pair = component.components(separatedBy: "=")
                if pair.count == 2 && pair[0] == "access_token" {
                    return pair[1]
                }
            }
        }

        throw URLError(.userAuthenticationRequired)
    }
}
