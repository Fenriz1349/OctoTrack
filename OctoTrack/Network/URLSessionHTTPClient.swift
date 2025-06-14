//
//  URLSessionHTTPClient.swift
//  OctoTrack
//
//  Created by Julien Cotte on 17/02/2025.
//

import Foundation

protocol HTTPClient {
    func request(from request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func request(from request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        guard let httpURLResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        return (data, httpURLResponse)
    }
}
