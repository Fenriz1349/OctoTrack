//
//  TokenMapperTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 13/06/2025.
//

import XCTest
@testable import OctoTrack

final class TokenMapperTests: XCTestCase {
    
    func test_getUUID_success() throws {
        // Given
        let validUUID = "550E8400-E29B-41D4-A716-446655440000"
        
        // When
        let uuid = try TokenMapper.getUUID(from: validUUID)
        
        // Then
        XCTAssertEqual(uuid.uuidString, validUUID)
    }
    
    func test_getUUID_invalidString() {
        // Given
        let invalidUUID = "not-a-uuid"
        
        // When/Then
        XCTAssertThrowsError(try TokenMapper.getUUID(from: invalidUUID)) { error in
            XCTAssertEqual(error as? URLError, URLError(.cannotDecodeRawData))
        }
    }
}
