//
//  UserMapper.swift
//  OctoTrack
//
//  Created by Julien Cotte on 17/02/2025.
//

import Foundation

enum UserMapper {

    struct UserDTO {
        let id: Int
        let login: String
        let avatarUrl: String

        func toUser() -> User {
            return User(id: id, login: login, avatarURL: avatarUrl)
        }
    }

    static func map(_ data: Data, and response: HTTPURLResponse) throws -> User {
        guard response.statusCode == 200 else {
            throw Errors.invalidResponse
        }

        let userDTO = try JSONDecoder().decode(UserDTO.self, from: data)
        return userDTO.toUser()
    }
}

extension UserMapper.UserDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarUrl = "avatar_url"
    }
}
