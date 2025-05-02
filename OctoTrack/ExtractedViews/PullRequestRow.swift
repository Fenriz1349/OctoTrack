//
//  PullRequestRow.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import SwiftUI

struct PullRequestRow: View {
    let pullRequest: PullRequest
    var body: some View {
        HStack {
            Text(pullRequest.title)
                .font(.system(size: 12))
            Spacer()
            LockLabel(status: pullRequest.state)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    PullRequestRow(pullRequest: PreviewPullRequests.architecturePRs.first!)
}
