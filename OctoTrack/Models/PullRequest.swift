//
//  PullRequest.swift
//  OctoTrack
//
//  Created by Julien Cotte on 13/02/2025.
//

import Foundation

struct PullRequest: Identifiable, Codable {

    let id: Int
    let number: Int
    var state: String
    var title: String
    let createdAt: Date
    var updateAt: Date?
    var closedAt: Date?
    var mergedAt: Date?
    var requestedReviewers: [User] = []
    var isDraft: Bool = false
}
