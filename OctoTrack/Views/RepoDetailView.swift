//
//  RepoDetailView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI

struct RepoDetailView: View {
    let repository: Repository
    private var pullRequests : [PullRequest] {
        if let list = repository.pullRequests {
            return list
        }
        return []
    }
    var body: some View {
        RepoHeader(repository: repository)
        List(pullRequests) { pullRequest in
                PullRequestRow(pullRequest: pullRequest)
            }
        }
}

#Preview {
    if let repository = PreviewContainer.getRepository() {
        return RepoDetailView(repository: repository)
            .previewWithContainer()
    } else {
        return Text("Repository not found")
    }
}
