//
//  OwnerLabel.swift
//  OctoTrack
//
//  Created by Julien Cotte on 25/04/2025.
//

import SwiftUI

struct OwnerLabel: View {
    var repository: Repository
    var body: some View {
        HStack(spacing: 12) {
            AsyncAvatarImage(avatarName: repository.owner.login, avatarUrl: repository.owner.avatarURL, size: 36)
                .overlay(
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text("owner")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(repository.owner.login)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            Spacer()
            GithubLink(link: "https://github.com/\(repository.owner.login)/\(repository.name)")
        }
    }
}

#Preview {
    OwnerLabel(repository: PreviewContainer.previewRepository)
}
