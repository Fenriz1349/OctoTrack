//
//  Repository.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//
import Foundation
import SwiftData

@Model final class Repository {
    @Attribute(.unique) var id: Int
    var name: String
    var repoDescription: String?
    var isPrivate: Bool
    var createdAt: Date
    var updatedAt: Date?
    var language: String?
    var priority: RepoPriority

    @Relationship var owner: Owner
    @Relationship var pullRequests: [PullRequest] = []

    @Relationship(deleteRule: .nullify, inverse: \User.repoList) var user: User?

    init(id: Int, name: String, repoDescription: String? = nil, isPrivate: Bool,
         owner: Owner, createdAt: Date, updatedAt: Date? = nil, language: String? = nil,
         priority: RepoPriority) {
        self.id = id
        self.name = name
        self.repoDescription = repoDescription
        self.isPrivate = isPrivate
        self.owner = owner
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.language = language
        self.priority = priority
    }
}

extension Repository {
    var mostRecentUpdate: Date {
        return updatedAt ?? createdAt
    }
}
