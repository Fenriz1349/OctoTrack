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
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text("createdAt".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(creationDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
            }

            if let updatedAt = updateDate {
                Divider()
                    .frame(height: 24)

                VStack(alignment: .trailing, spacing: 2) {
                    Text("lastUpdated".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(updatedAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                }
            }
        }
    }
}

#Preview {
    DateRow(creationDate: Date(), updateDate: Date())
}
