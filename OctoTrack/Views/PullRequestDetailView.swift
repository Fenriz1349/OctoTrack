//
//  PullRequestDetailView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import SwiftUI

struct PullRequestDetailView: View {
    let pullRequest: PullRequest
    let repository: Repository
#warning("inserer dans un VM")
    private var link: String {
        "https://github.com/\(repository.owner.login)/\(repository.name)/pull/\(pullRequest.number)"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                RepoHeader(repository: repository, isCompact: true)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("#\(pullRequest.number)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        if pullRequest.isDraft {
                            Text("draft")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.customGray.opacity(0.2))
                                )
                                .foregroundColor(.customGray)
                        }
                        Spacer()
                        LockLabel(status: pullRequest.state, withText: true)
                    }

                    Text(pullRequest.title)
                        .fontWeight(.bold)

                    Divider()
                        .background(Color("DividerColor"))

                    DateRow(creationDate: pullRequest.createdAt, updateDate: pullRequest.updatedAt,
                            mergedAt: pullRequest.mergedAt, closedAt: pullRequest.closedAt)

                    Divider()
                        .background(Color("DividerColor"))
                    PullRequestTimeline(pullRequest: pullRequest)
                    GithubLink(link: link)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .primary.opacity(0.1), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal)
            }
        }
        .navigationTitle("PR#\(pullRequest.number)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PullRequestDetailView(pullRequest: PreviewPullRequests.architecturePRs.first!,
                          repository: PreviewContainer.previewRepository)
}
