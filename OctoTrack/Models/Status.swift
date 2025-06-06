//
//  PullRequestStatus.swift
//  OctoTrack
//
//  Created by Julien Cotte on 25/04/2025.
//

import SwiftUI

enum Status: String, CaseIterable {
    case open
    case created
    case updated
    case closed
    case merged
    case publicRepo
    case privateRepo

    var text: String {
        switch self {
        case .created: String(localized: "created")
        case .open: String(localized: "open")
        case .updated: String(localized: "updated")
        case .closed: String(localized: "closed")
        case .merged: String(localized: "merged")
        case .publicRepo: String(localized: "public")
        case .privateRepo: String(localized: "private")
        }
    }

    var color: Color {
        switch self {
        case .created: .blue
        case .updated: .orange
        case .open, .publicRepo: .green
        case .closed, .privateRepo: Color(.systemGray5)
        case .merged: .purple
        }
    }

    var icon: String {
        switch self {
        case .created: IconsName.plus.rawValue
        case .updated: IconsName.update.rawValue
        case .open, .publicRepo: IconsName.lockOpen.rawValue
        case .closed, .privateRepo: IconsName.lockClose.rawValue
        case .merged: IconsName.merge.rawValue
        }
    }

    static func getRepoStatus(_ repository: Repository) -> Status {
        repository.isPrivate ? .privateRepo : .publicRepo
    }

    static func getPullRequestState(_ pullRequest: PullRequest) -> Status {
        pullRequest.mergedAt != nil ? .merged : pullRequest.closedAt != nil ? .closed : .open
    }
}
