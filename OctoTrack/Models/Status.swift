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

    var value: String {
        switch self {
        case .created: "created".localized
        case .open: "open".localized
        case .updated: "updated".localized
        case .closed: "closed".localized
        case .merged:"merged".localized
        case .publicRepo: "public".localized
        case .privateRepo: "private".localized
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
