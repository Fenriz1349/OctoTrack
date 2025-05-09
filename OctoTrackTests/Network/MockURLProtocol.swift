//
//  MockURLProtocol.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 09/05/2025.
//

import Foundation
@testable import OctoTrack

class MockURLProtocol: URLProtocol {
    
    enum ResponseType {
        case success(HTTPURLResponse, Data)
        case failure(Error)
    }
    
    static var requestHandler: ((URLRequest) -> ResponseType)?
    static var responseMap: [URL: ResponseType] = [:]
    static var requestCount = 0
    static var requestHistory: [URLRequest] = []
    
    static func reset() {
        requestHandler = nil
        responseMap.removeAll()
        requestCount = 0
        requestHistory.removeAll()
    }
    
    static func registerResponse(for url: URL, response: ResponseType) {
        responseMap[url] = response
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        MockURLProtocol.requestCount += 1
        MockURLProtocol.requestHistory.append(request)
        
        let responseType: ResponseType
        
        if let url = request.url, let mappedResponse = MockURLProtocol.responseMap[url] {
            responseType = mappedResponse
        } else if let handler = MockURLProtocol.requestHandler {
            responseType = handler(request)
        } else {
            let error = NSError(
                domain: NSURLErrorDomain,
                code: NSURLErrorUnknown,
                userInfo: [NSLocalizedDescriptionKey: "No response configured for this request"]
            )
            client?.urlProtocol(self, didFailWithError: error)
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        switch responseType {
        case .success(let response, let data):
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
            
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
    }
}

extension URLSession {
    static var mockSession: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
