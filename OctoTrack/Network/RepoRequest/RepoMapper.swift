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
        let description: String?
        let owner: OwnerDTO
        let createdAt: Date
        let updateAt: Date?
        let language: String?

        func toRepo() -> Repository {
            let repoOwner = Owner(
                            id: owner.id,
                            login: owner.login,
                            avatarURL: owner.avatarUrl
                        )
            return Repository(id: id, name: name, repoDescription: description,
                              isPrivate: isPrivate, owner: repoOwner,
                              createdAt: createdAt, updatedAt: updateAt, language: language, priority: .low)
        }
    }

    struct OwnerDTO {
        let id: Int
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
        case id, login
        case avatarUrl = "avatar_url"
    }
}

extension RepoMapper.RepoDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, name, owner, language, description
        case createdAt = "created_at"
        case updateAt = "updated_at"
        case isPrivate = "private"
    }
}
