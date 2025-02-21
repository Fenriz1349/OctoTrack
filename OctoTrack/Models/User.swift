//
//  User.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI

@Observable final class User: Identifiable, Codable {
    let id: Int
    let login: String
    var avatarURL: String
    var repoList: [Repository]
    var avatar: AvatarProperties {
        AvatarProperties(name: login, url: avatarURL)
    }

    init(id: Int, login: String, avatarURL: String, repoList: [Repository] = []) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.repoList = repoList
    }
}
