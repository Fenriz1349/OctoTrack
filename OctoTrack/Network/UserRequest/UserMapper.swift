//
//  UserMapper.swift
//  OctoTrack
//
//  Created by Julien Cotte on 17/02/2025.
//

import Foundation

enum UserMapper {
    
    struct UserDTO: Decodable {
        let id: Int
        let login: String
        let avatar_url: String

        func toUser() -> User {
            return User(id: id, login: login, avatarURL: avatar_url)
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
