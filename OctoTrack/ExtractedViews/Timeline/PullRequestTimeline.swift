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

            if let mergedDate = pullRequest.mergedAt {
                TimelineEvent(
                    date: mergedDate,
                    status: .merged
                )
            } else if let closedDate = pullRequest.closedAt {
                TimelineEvent(
                    date: closedDate,
                    status: .closed
                )
            }

            if let updateDate = pullRequest.updatedAt,
               updateDate != pullRequest.createdAt {
                TimelineEvent(
                    date: updateDate,
                    status: .updated
                )
            }
            TimelineEvent(
                date: pullRequest.createdAt,
                status: .created,
                notSolo: pullRequest.mergedAt == nil && pullRequest.closedAt == nil
            )
        }
    }
}

#Preview {
    PullRequestTimeline(pullRequest: PreviewPullRequests.architecturePRs.first!)
}
