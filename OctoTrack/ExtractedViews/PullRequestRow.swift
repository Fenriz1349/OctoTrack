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
        NavigationLink(destination: PRDetailView(pullRequest: pullRequest) ) {
            HStack {
                Text(pullRequest.title)

                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    PullRequestRow(pullRequest: PreviewPullRequests.architecturePRs.first!)
}
