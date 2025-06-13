//
//  RepoDetailView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI

struct RepoDetailView: View {
    @State private var viewModel: RepoDetailsViewModel
    @State private var showPriorityPicker = false

    var sortedPullRequests: [PullRequest] {
        viewModel.repository.pullRequests.sorted { $0.createdAt > $1.createdAt }
    }

    init(repository: Repository, dataManager: UserDataManager) {
            self._viewModel = State(initialValue: RepoDetailsViewModel(repository: repository,
                                                                       dataManager: dataManager))
        }

    var body: some View {
        VStack(spacing: 20) {
            RepoHeader(repository: viewModel.repository, viewModel: viewModel)

            if viewModel.feedback.message != nil {
                FeedbackLabel(feedback: viewModel.feedback, showIcon: false)
            }

            List(sortedPullRequests) { pullRequest in
                NavigationLink(destination: PullRequestDetailView(pullRequest: pullRequest,
                                                         repository: viewModel.repository) ) {
                    PullRequestRow(pullRequest: pullRequest)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deletePullRequest(pullRequest)
                            } label: {
                                CustomButtonIcon(icon: IconsName.trash, color: .red)
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
    }
}

#Preview {
    RepoDetailView(repository: PreviewContainer.repositories.first!, dataManager: PreviewContainer.mockDataManager)
        .previewWithContainer()
}
