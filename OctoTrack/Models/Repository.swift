//
//  Repository.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import Foundation

struct Repository: Identifiable, Codable {
    let id: Int
    let name: String
    var description: String?
    let isPrivate: Bool
    var pullRequests: [PullRequest] = []
    var commits: [Commit] = []
    let avatar: AvatarProperties
    let createdAt: Date
    var updatedAt: Date?
    var language: [String] = []
}
