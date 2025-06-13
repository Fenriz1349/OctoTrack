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
    let mergedcount: Int
    let language: String?

    var body: some View {
        HStack {
            CountingCell(text: "total", count: totalCount)
            Divider()
                .frame(height: 24)
            CountingCell(text: "open", count: openCount)
            Divider()
                .frame(height: 24)
            CountingCell(text: "closed", count: closedCount)
            Divider()
                .frame(height: 24)
            CountingCell(text: "merged", count: mergedcount)
            if let language = language {
                Divider()
                    .frame(height: 24)
                Text(language)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    PRCategoryCounterRow(totalCount: 8, openCount: 4, closedCount: 1, mergedcount: 3, language: "swift")
}
