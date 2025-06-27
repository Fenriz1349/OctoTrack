//
//  RepoDetailView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI

struct RepoDetailView: View {
    @StateObject var viewModel: RepoDetailsViewModel

    var body: some View {
        VStack(spacing: 20) {
            RepoHeader(repository: viewModel.repository, viewModel: viewModel)

            if viewModel.feedback.message != nil {
                FeedbackLabel(feedback: viewModel.feedback, showIcon: false)
            }

            List(viewModel.sortedPullRequests) { pullRequest in
                NavigationLink(destination: PullRequestDetailView(pullRequest: pullRequest,
                                                         repository: viewModel.repository) ) {
                    PullRequestRow(pullRequest: pullRequest)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deletePullRequest(pullRequest)
                            } label: {
                                CustomButtonIcon(icon: IconsName.trash, color: .customRed)
                            }
                        }
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                await viewModel.getAllPullRequests()
            }
        }
        .padding(.horizontal, 10)
        .onAppear {
            viewModel.onViewAppear()
        }
    }
}

#Preview {
    RepoDetailView(viewModel: RepoDetailsViewModel(repository: PreviewContainer.previewRepository, dataManager: PreviewContainer.mockDataManager) )
        .previewWithContainer()
}
