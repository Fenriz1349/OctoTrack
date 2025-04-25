//
//  PRCategoryCounterRow.swift
//  OctoTrack
//
//  Created by Julien Cotte on 25/04/2025.
//

import SwiftUI

struct PRCategoryCounterRow: View {
    let totalCount: Int
    let openCount: Int
    let closedCount: Int
    let language: String?

    var body: some View {
        HStack {
            CountingCell(text: "total".localized, count: totalCount)
            Divider()
                .frame(height: 24)
            CountingCell(text: "open".localized, count: openCount)
            Divider()
                .frame(height: 24)
            CountingCell(text: "closed".localized, count: closedCount)
            Divider()
                .frame(height: 24)
            if let language = language {
                Text(language)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    PRCategoryCounterRow(totalCount: 5, openCount: 4, closedCount: 1, language: "swift")
}
