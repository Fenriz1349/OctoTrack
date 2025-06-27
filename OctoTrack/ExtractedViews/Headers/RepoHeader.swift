//
//  RepoHeader.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import SwiftUI

struct RepoHeader: View {
    @Bindable var repository: Repository
    var viewModel: RepoDetailsViewModel?
    var repoHeaderViewModel :  RepoHeaderViewModel {
        RepoHeaderViewModel(repository: repository)
    }
    var isCompact: Bool = false

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(repository.name)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                LockLabel(status: Status.getRepoStatus(repository))
            }

            OwnerLabel(repository: repository)
            if !isCompact {
                Divider()
                    .background(Color("DividerColor"))
                PRCategoryCounterRow(totalCount: repoHeaderViewModel.totalPRCount,
                                     openCount: repoHeaderViewModel.openPRCount,
                                     closedCount: repoHeaderViewModel.closedPRCount,
                                     mergedcount: repoHeaderViewModel.mergedPRCount,
                                     language: repoHeaderViewModel.repository.language)
                Divider()
                    .background(Color("DividerColor"))
                DateRow(creationDate: repository.createdAt,
                        updateDate: repository.updatedAt,
                        mergedAt: nil, closedAt: nil,
                        viewModel: viewModel)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    RepoHeader(repository: PreviewContainer.previewRepository, isCompact: false)
        .previewWithContainer()
}
