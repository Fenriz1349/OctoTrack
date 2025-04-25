//
//  LockLabel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 25/04/2025.
//

import SwiftUI

struct LockLabel: View {
    let isPrivate: Bool
    var withText: Bool = true
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: (isPrivate ?
                               IconsName.lockClose : IconsName.lockOpen).rawValue)
            .foregroundColor(.secondary)
            if withText {
                Text(isPrivate ?
                     "private".localized : "public".localized)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(isPrivate ? Color(UIColor.systemGray5) : Color(UIColor.green))
        )
    }
}

#Preview {
    LockLabel(isPrivate: false, withText: false)
}
