//
//  UserEndpoint.swift
//  OctoTrack
//
//  Created by Julien Cotte on 17/02/2025.
//

import Foundation

enum UserEndpoint {

    static func userInfoRequest(with token: String) throws -> URLRequest {
        return try EndpointBuilder.user(token: token).buildRequest()
    }
}
