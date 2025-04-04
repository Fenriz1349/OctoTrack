//
//  PullRequestMapper.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import Foundation

enum PullRequestMapper {
    struct PullRequestDTO {
        var id: Int
        var number: Int
        var state: String
        var title: String
        var createdAt: Date
        var updateAt: Date?
        var closedAt: Date?
        var mergedAt: Date?
        var isDraft: Bool

        func toPullRequest() -> PullRequest {
            return PullRequest(id: id, number: number, state: state,
                               title: title, createdAt: createdAt, isDraft: isDraft)
        }
    }

    static func map(_ data: Data, and response: HTTPURLResponse) throws -> PullRequest {
        guard response.statusCode == 200 else {
            throw Errors.invalidResponse
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let pullRequestDTO = try decoder.decode(PullRequestDTO.self, from: data)
        return pullRequestDTO.toPullRequest()
    }

    static func mapList(_ data: Data, and response: HTTPURLResponse) throws -> [PullRequest] {
        guard response.statusCode == 200 else {
            throw Errors.invalidResponse
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let pullRequestDTOs = try decoder.decode([PullRequestDTO].self, from: data)
        return pullRequestDTOs.map { $0.toPullRequest() }
    }
}

extension PullRequestMapper.PullRequestDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, number, state, title
        case isDraft = "draft"
        case createdAt = "created_at"
        case updateAt = "updated_at"
        case closedAt = "closed_at"
        case mergedAt = "merged_at"
    }
}
