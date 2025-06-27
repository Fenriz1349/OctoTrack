//
//  UserHeader.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import SwiftUI

struct UserHeader: View {
   let user: User
   let repoCount: Int
   let refreshID: Int
   var isCompact: Bool = false

   private var viewModel: UserHeaderViewModel {
       UserHeaderViewModel(user: user, repoCount: repoCount)
   }

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                AsyncAvatarImage(avatarName: user.login, avatarUrl: user.avatarURL, size: viewModel.size)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.accentColor, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
                    .shadow(color: .primary.opacity(0.2), radius: 10, x: 0, y: 5)
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text(user.login)
                        .font(.title)
                        .fontWeight(.bold)
                    if !isCompact {
                        GithubLink(link: viewModel.githubLink)
                    }
                    HStack(spacing: 6) {
                        Image(systemName: "folder.fill")
                            .foregroundColor(.orange)
                        Text(viewModel.trackedReposText)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: viewModel.size, alignment: .top)
            if let formattedUpdate = viewModel.formattedLastUpdate, !isCompact {
                Text(formattedUpdate)
                    .foregroundColor(.secondary)
            }
        }
        .id(refreshID)
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    UserHeader(user: PreviewContainer.user, repoCount: 3, refreshID: 0, isCompact: false)
}
