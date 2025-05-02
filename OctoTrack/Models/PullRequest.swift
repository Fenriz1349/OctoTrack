//
//  PullRequest.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import SwiftUI
import SwiftData

@Model final class PullRequest: Identifiable {
    var id: Int
    var number: Int
    var body: String?
    var title: String
    var createdAt: Date
    var updateAt: Date?
    var closedAt: Date?
    var mergedAt: Date?
    var isDraft: Bool = false

    var state: Status {
        Status.getPullRequestState(self)
    }

    init(id: Int, number: Int, body: String? = nil, title: String, createdAt: Date,
         updateAt: Date? = nil, closedAt: Date? = nil, mergedAt: Date? = nil, isDraft: Bool) {
        self.id = id
        self.number = number
        self.body = body
        self.title = title
        self.createdAt = createdAt
        self.updateAt = updateAt
        self.closedAt = closedAt
        self.mergedAt = mergedAt
        self.isDraft = isDraft
    }
}
