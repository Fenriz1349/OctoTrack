//
//  User.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI
import SwiftData

@Model final class User {
    @Attribute(.unique) var id: Int
    @Attribute(.unique) var login: String
    var avatarURL: String

    @Relationship(deleteRule: .cascade) var repoList: [Repository] = []

    init(id: Int, login: String, avatarURL: String, repoList: [Repository]) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.repoList = repoList
    }

    func toOwner() -> Owner {
        return Owner(id: id, login: login, avatarURL: avatarURL)
    }
}
