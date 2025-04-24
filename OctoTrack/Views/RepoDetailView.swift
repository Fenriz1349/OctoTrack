//
//  RepoDetailView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI

struct RepoDetailView: View {
    let repository: Repository
    
    var body: some View {
        RepoHeader(repository: repository)
        List(repository.pullRequests) { pullRequest in
            PullRequestRow(pullRequest: pullRequest)
        }
    }
}

#Preview {
    if let repository = PreviewContainer.getRepository() {
        RepoDetailView(repository: repository)
            .previewWithContainer()
    } else {
        Text("Repository not found")
    }
}
