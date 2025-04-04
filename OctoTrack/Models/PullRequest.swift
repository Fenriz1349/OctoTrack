//
//  PullRequest.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import SwiftUI

@Observable final class PullRequest {
    var id: Int
    var number: Int
    var state: String
    var title: String
    var createdAt: Date
    var updateAt: Date?
    var closedAt: Date?
    var mergedAt: Date?
    var isDraft: Bool = false

    var repository: Repository?

    init(id: Int, number: Int, state: String, title: String, createdAt: Date,
         updateAt: Date? = nil, closedAt: Date? = nil, mergedAt: Date? = nil, isDraft: Bool) {
        self.id = id
        self.number = number
        self.state = state
        self.title = title
        self.createdAt = createdAt
        self.updateAt = updateAt
        self.closedAt = closedAt
        self.mergedAt = mergedAt
        self.isDraft = isDraft
    }
}
