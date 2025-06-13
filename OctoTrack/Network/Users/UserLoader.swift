//
//  UserRequest.swift
//  OctoTrack
//
//  Created by Julien Cotte on 17/02/2025.
//

import Foundation

final class UserLoader {

    private let client: HTTPClient

    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }

    func userLoader(from request: URLRequest) async throws -> User {
        let (data, response) = try await client.request(from: request)
        let user =  try UserMapper.map(data, and: response)

        return user
    }
}
