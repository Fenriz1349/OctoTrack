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

    func requestUser(from request: URLRequest) async throws -> Data {
        let (data, response) = try await client.request(from: request)

        return data
    }
}
