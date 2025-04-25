//
//  CountingCell.swift
//  OctoTrack
//
//  Created by Julien Cotte on 25/04/2025.
//

import SwiftUI

struct CountingCell: View {
    let text: String
    let count: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(text.localized)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(count.description)
                .font(.headline)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    CountingCell(text: "total".localized, count: 5)
}
