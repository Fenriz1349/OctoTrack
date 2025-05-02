//
//  PullRequestTimeline.swift
//  OctoTrack
//
//  Created by Julien Cotte on 02/05/2025.
//

import SwiftUI

struct PullRequestTimeline: View {
    let pullRequest: PullRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("timeline")
                .font(.headline)
                .padding(.bottom, 8)

            TimelineEvent(
                date: pullRequest.createdAt,
                status: .created,
                isLast: pullRequest.closedAt == nil && pullRequest.mergedAt == nil
            )
            if let updateDate = pullRequest.updateAt {
                TimelineEvent(
                    date: updateDate,
                    status: .updated,
                    isLast: pullRequest.closedAt == nil && pullRequest.mergedAt == nil
                )
            }
            if let mergedDate = pullRequest.mergedAt {
                TimelineEvent(
                    date: mergedDate,
                    status: .merged,
                    isLast: true
                )
            } else if let closedDate = pullRequest.closedAt {
                TimelineEvent(
                    date: closedDate,
                    status: .closed,
                    isLast: true
                )
            }
        }
    }
}

#Preview {
    PullRequestTimeline(pullRequest: PreviewPullRequests.architecturePRs.first!)
}
