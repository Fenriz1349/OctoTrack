//
//  HTTPClientMock.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/03/2025.
//

import XCTest
@testable import OctoTrack

final class HTTPClientStub: HTTPClient {
    private let result: Result<(Data, HTTPURLResponse), Error>
    private(set) var requests: [URLRequest] = []

    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }

    func request(from request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        requests.append(request)
        return try result.get()
    }
}
