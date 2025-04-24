//
//  Owner.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/03/2025.
//

import SwiftData

@Model final class Owner {
    @Attribute(.unique) var id: Int
    var login: String
    var avatarURL: String
    
//    @Relationship(inverse: \Repository.owner) var repositories: [Repository] = []
    
    init(id: Int, login: String, avatarURL: String) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
    }
}
