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
}

extension User {

    func toOwner() -> Owner {
        return Owner(id: id, login: login, avatarURL: avatarURL)
    }
}
