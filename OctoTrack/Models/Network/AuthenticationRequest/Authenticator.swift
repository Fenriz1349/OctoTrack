//
//  Authenticator.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/02/2025.
//

import Foundation

final class Authenticator {

    private let client: HTTPClient

    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }

    func requestToken(from request: URLRequest) async throws -> String {
        let (data, response) = try await client.request(from: request)
        let token = try AuthenticationMapper.map(data, and: response)

        return token
    }
}
