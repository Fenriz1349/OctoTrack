//
//  RepoMapper.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import Foundation

enum RepoMapper {

    struct RepoDTO {
        let id: Int
        let name: String
        let isPrivate: Bool
        let owner: OwnerDTO
        let createdAt: Date
        let language: String?

        func toRepo() -> Repository {
            let avatar = AvatarProperties(name: owner.login, url: owner.avatarUrl)
            return Repository(id: id, name: name, isPrivate: isPrivate, avatar: avatar,
                              createdAt: createdAt, language: language.map { [$0] } ?? [])
        }
    }

    struct OwnerDTO {
        let login: String
        let avatarUrl: String
    }

    static func map(_ data: Data, and response: HTTPURLResponse) throws -> Repository {
        guard response.statusCode == 200 else {
            throw Errors.invalidResponse
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let repoDTO = try decoder.decode(RepoDTO.self, from: data)
        return repoDTO.toRepo()
    }
}

extension RepoMapper.OwnerDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}

extension RepoMapper.RepoDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, name, owner, language
        case createdAt = "created_at"
        case isPrivate = "private"
    }
}
