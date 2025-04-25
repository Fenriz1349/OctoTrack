//
//  LockLabel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 25/04/2025.
//

import SwiftUI

struct LockLabel: View {
    let isPrivate: Bool
    var isPrivateLabel: Bool = true
    var withText: Bool = true
    private var textToDisplay: String {
        if isPrivateLabel {
            return isPrivate ? "private".localized : "public".localized
        } else {
            return isPrivate ? "closed".localized : "open".localized
        }
    }
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: (isPrivate ?
                               IconsName.lockClose : IconsName.lockOpen).rawValue)
            .foregroundColor(.secondary)
            if withText {
                Text(textToDisplay)
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
    LockLabel(isPrivate: false, isPrivateLabel: false)
}
