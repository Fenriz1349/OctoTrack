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
    var repoDescription: String? = nil
    var isPrivate: Bool
    var createdAt: Date
    var updatedAt: Date? = nil
    var language: String? = nil

    @Relationship(deleteRule: .cascade) var owner: Owner
    @Relationship(deleteRule: .cascade) var pullRequests: [PullRequest]? = []

    init(id: Int, name: String, repoDescription: String?, isPrivate: Bool, owner: Owner, createdAt: Date, updatedAt: Date?, language: String?) {
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
