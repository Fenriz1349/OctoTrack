//
//  RepoMapper.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import Foundation

enum RepoMapper {
    
    struct RepoDTO: Decodable {
        let id: Int
        let name: String
        let isPrivate: Bool
        let owner: OwnerDTO
        let created_at: Date
        let language: String?
        
        private enum CodingKeys: String, CodingKey {
                case id, name, owner, created_at, language
                case isPrivate = "private"
            }
        
        func toRepo() -> Repository {
            let avatar = AvatarProperties(name: owner.login, url: owner.avatar_url)
            return Repository(id: id, name: name, isPrivate: isPrivate, avatar: avatar, createdAt: created_at, language: language.map { [$0] } ?? [])
        }
    }
    
    struct OwnerDTO: Decodable {
        let login: String
        let avatar_url: String
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
