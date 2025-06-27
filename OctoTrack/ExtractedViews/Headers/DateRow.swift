//
//  DateRow.swift
//  OctoTrack
//
//  Created by Julien Cotte on 25/04/2025.
//

import SwiftUI

struct DateRow: View {
    let creationDate: Date
    let updateDate: Date?
    let mergedAt: Date?
    let closedAt: Date?
    var viewModel: RepoDetailsViewModel?

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .center, spacing: 2) {
                Text("createdAt")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(creationDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
            }

            if let updatedAt = updateDate {
                Divider()
                    .background(Color("DividerColor"))
                    .frame(height: 24)
                VStack(alignment: .center, spacing: 2) {
                    Text("updated")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(updatedAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                }
            }

            if let mergedAt = mergedAt {
                Divider()
                    .background(Color("DividerColor"))
                    .frame(height: 24)
                VStack(alignment: .center, spacing: 2) {
                    Text("merged")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(mergedAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                }
            } else if let closedAt = closedAt {
                Divider()
                    .background(Color("DividerColor"))
                    .frame(height: 24)
                VStack(alignment: .center, spacing: 2) {
                    Text("closed")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(closedAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                }
            }
            if let viewModel = viewModel {
                Divider()
                    .background(Color("DividerColor"))
                    .frame(height: 24)
                CompactPriorityMenu(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    DateRow(creationDate: Date(), updateDate: Date(), mergedAt: nil, closedAt: nil)
}
