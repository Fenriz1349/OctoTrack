//
//  AuthenticationMapper.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation

enum AuthenticationMapper {

    private struct Root: Decodable {
        let token: String
    }

    enum Error: Swift.Error {
        case invalidResponse
    }

    static func map(_ data: Data, and response: HTTPURLResponse) throws -> String {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidResponse
        }

        return root.token
    }
}
