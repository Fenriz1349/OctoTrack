//
//  User.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import Foundation
import SwiftData

@Model final class User {
    @Attribute(.unique) var id: Int
    @Attribute(.unique) var login: String
    var isActiveUser: Bool = false
    var avatarURL: String
    var lastUpdate: Date?

    @Relationship(deleteRule: .nullify) var repoList: [Repository] = []

    init(id: Int, login: String, avatarURL: String, repoList: [Repository], lastUpdate: Date? = nil) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.repoList = repoList
        self.lastUpdate = lastUpdate
    }

    func toOwner() -> Owner {
        return Owner(id: id, login: login, avatarURL: avatarURL)
    }
}

extension User {
    var trackedReposText: String {
        switch repoList.count {
        case 0: return String(localized: "noTrackedRepos")
        case 1: return String(localized: "oneTrackedRepo")
        default: return String(localized: "\(repoList.count) reposTracked")
        }
    }
}
