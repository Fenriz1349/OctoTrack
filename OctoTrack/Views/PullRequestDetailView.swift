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
                                        .fill(Color.gray.opacity(0.2))
                                )
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        LockLabel(status: pullRequest.state, withText: true)
                    }

                    Text(pullRequest.title)
                        .fontWeight(.bold)

                    Divider()
                    DateRow(creationDate: pullRequest.createdAt, updateDate: pullRequest.updatedAt,
                            mergedAt: pullRequest.mergedAt, closedAt: pullRequest.closedAt)

                    Divider()

                    PullRequestTimeline(pullRequest: pullRequest)
                    GithubLink(link: link)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
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
