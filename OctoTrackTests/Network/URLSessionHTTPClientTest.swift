//
//  URLSessionHTTPClientTest.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/03/2025.
//

import XCTest
@testable import OctoTrack

final class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_performsGETRequestWithURL() async {
        let sut = URLSessionHTTPClient()
        let url = anyURL()
        let request = URLRequest(url: url)

        do {
            _ = try? await sut.request(from: request)
        } catch {
        }
    }
}
