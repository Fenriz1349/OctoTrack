//
//  RepoDetailView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI
import SwiftData

struct RepoDetailView: View {
    @State private var viewModel: PullRequestViewModel
    @State private var showPriorityPicker = false

    init(repository: Repository, dataManager: UserDataManager) {
            self._viewModel = State(initialValue: PullRequestViewModel(repository: repository,
                                                                       dataManager: dataManager))
        }

    var body: some View {
        VStack(spacing: 20) {
            RepoHeader(repository: viewModel.repository)
            Menu {
                ForEach(RepoPriority.allCases, id: \.self) { priority in
                    Button {
                        viewModel.updateRepositoryPriority(priority)
                    } label: {
                        HStack {
                            Image(systemName: priority.icon.rawValue)
                            Text(priority.name)
                        }
                    }
                }
            } label: {
                CustomButtonLabel(
                    iconLeading: viewModel.repository.priority.icon,
                    iconTrailing: IconsName.down,
                    message: viewModel.repository.priority.name,
                    color: viewModel.repository.priority.color
                )
            }

            if viewModel.feedback.message != nil {
                FeedbackLabel(feedback: viewModel.feedback, showIcon: false)
            }

            List(viewModel.repository.pullRequests) { pullRequest in
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
        .padding(.horizontal, 20)
    }
}

#Preview {
    RepoDetailView(repository: PreviewContainer.repositories.first!, dataManager: PreviewContainer.mockDataManager)
        .previewWithContainer()
}
