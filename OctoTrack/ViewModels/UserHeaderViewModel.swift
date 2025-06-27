//
//  UserHeaderViewModel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 27/06/2025.
//

import SwiftUI

struct UserHeaderViewModel {
    let user: User
    let repoCount: Int
    let size: CGFloat = 100
    
    var trackedReposText: String {
        switch repoCount {
        case 0: return String(localized: "noTrackedRepos")
        case 1: return String(localized: "oneTrackedRepo")
        default: return String(localized: "\(repoCount) reposTracked")
        }
    }
    
    var githubLink: String {
        return "https://github.com/\(user.login)"
    }
    
    var formattedLastUpdate: String? {
        guard let lastUpdate = user.lastUpdate else { return nil }
        return "lastUpdate \(lastUpdate.formatted(date: .abbreviated, time: .shortened))"
    }
}
