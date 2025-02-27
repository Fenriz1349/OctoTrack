//
//  PreviewModels.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import Foundation

struct PreviewModels {
    static let compagny = User(id: 1, login: "BatmanInteractive", avatarURL: "https://avatars.githubusercontent.com/u/198871564?v=4")
    static let previewRepo: Repository = Repository(id: 1, name: "Project 1", isPrivate: false, avatar: avatarCompagny, createdAt: Date())
    static var repositories: [Repository] {[
        Repository(id: 0, name: "Project 1", isPrivate: true, avatar: avatarPreviewUser, createdAt: Date()),
        Repository(id: 1, name: "Project 2", isPrivate: false, avatar: avatarCompagny, createdAt: Date()),
        Repository(id: 2, name: "Project 3", isPrivate: false, avatar: avatarCompagny, createdAt: Date())
        
    ]}
    static var avatarCompagny: AvatarProperties {
        AvatarProperties(name: "BatmanInteractive", url:  "https://avatars.githubusercontent.com/u/198871564?v=4")
    }
    static var avatarPreviewUser: AvatarProperties {
        AvatarProperties(name: "HackerMan", url: "https://avatars.githubusercontent.com/u/198871564?v=4")
    }
    static var previewUser: User {
        User(id:2, login: "HackerMan", avatarURL:  "https://avatars.githubusercontent.com/u/198871564?v=4", repoList: PreviewModels.repositories)
    }
}
