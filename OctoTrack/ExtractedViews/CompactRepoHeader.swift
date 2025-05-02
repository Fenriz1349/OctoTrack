//
//  CompactRepoHeader.swift
//  OctoTrack
//
//  Created by Julien Cotte on 02/05/2025.
//

import SwiftUI

struct CompactRepoHeader: View {
    let repository: Repository

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(repository.name)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                LockLabel(status: Status.getRepoStatus(repository))
            }
            HStack {
                AsyncAvatarImage(avatarName: repository.owner.login,
                                 avatarUrl: repository.owner.avatarURL,
                                 size: 24)
                Text(repository.owner.login)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                if let language = repository.language {
                    Spacer()
                    Text(language)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.gray.opacity(0.2))
                        )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
        .padding(.horizontal)
    }
}

#Preview {
    CompactRepoHeader(repository: PreviewContainer.previewRepository)
}
