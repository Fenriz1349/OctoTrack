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

    @Relationship(deleteRule: .cascade) var owner: Owner
    // Transcient is use to prevent the saving of this var in SwiftData
    @Transient var pullRequests: [PullRequest]? = []

    init(id: Int, name: String, repoDescription: String? = nil, isPrivate: Bool,
         owner: Owner, createdAt: Date, updatedAt: Date? = nil, language: String? = nil) {
        self.id = id
        self.name = name
        self.repoDescription = repoDescription
        self.isPrivate = isPrivate
        self.owner = owner
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.language = language
    }
}
