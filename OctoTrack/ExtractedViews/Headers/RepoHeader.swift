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
    var isCompact: Bool = false

    private var openPRCount: Int {
        repository.pullRequests.filter { $0.state == .open }.count
    }

    private var closedPRCount: Int {
        repository.pullRequests.filter { $0.state == .closed }.count
    }

    private var mergedPRCount: Int {
        repository.pullRequests.filter { $0.state == .merged }.count
    }

    private var totalPRCount: Int {
        repository.pullRequests.count
    }

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
                PRCategoryCounterRow(totalCount: totalPRCount,
                                     openCount: openPRCount,
                                     closedCount: closedPRCount,
                                     mergedcount: mergedPRCount,
                                     language: repository.language)
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
