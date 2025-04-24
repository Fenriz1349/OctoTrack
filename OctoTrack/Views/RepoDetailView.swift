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

    init(repository: Repository, dataManager: UserDataManager) {
            self._viewModel = State(initialValue: PullRequestViewModel(repository: repository,
                                                                       dataManager: dataManager))
        }

    var body: some View {
        VStack(spacing: 20) {
            RepoHeader(repository: viewModel.repository)
            Button {
                Task {
                    await viewModel.updatePullRequests()
                }
            } label: {
                CustomButtonLabel(icon: IconsName.refresh.rawValue,
                                  message: "refresh.PR".localized,
                                  color: .blue)
            }
            if viewModel.repository.pullRequests.isEmpty {
                Text("noPR".localized)
                Spacer()
            } else {
                List(viewModel.repository.pullRequests) { pullRequest in
                    PullRequestRow(pullRequest: pullRequest)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Repository.self, configurations: config)
        let mockDataManager = UserDataManager(modelContext: ModelContext(container))

        return RepoDetailView(repository: PreviewContainer.repositories.first!, dataManager: mockDataManager)
            .previewWithContainer()
    } catch {
        return Text("Erreur: \(error.localizedDescription)")
    }
}
