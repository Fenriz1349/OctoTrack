//
//  LockLabel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 25/04/2025.
//

import SwiftUI

struct LockLabel: View {
    let status: Status
    var withText: Bool = true

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.icon)
            .foregroundColor(.secondary)
            if withText {
                Text(status.text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(status.color)
        )
    }
}

#Preview {
    LockLabel(status: .open)
}
