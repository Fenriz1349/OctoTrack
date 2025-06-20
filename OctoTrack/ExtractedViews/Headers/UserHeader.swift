//
//  UserHeader.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import SwiftUI
import SwiftData

struct UserHeader: View {
    var isCompact: Bool = false

    /// Use Query to updateUI when remove/ add elements
    @Query(filter: #Predicate<User> { $0.isActiveUser })
    private var activeUsers: [User]
    private var user: User? {
        activeUsers.first
    }

    private let size: CGFloat = 100

    var body: some View {
        if let user = user {
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    AsyncAvatarImage(avatarName: user.login, avatarUrl: user.avatarURL, size: size)
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
                        if !isCompact { GithubLink(link: "https://github.com/\(user.login)") }
                        HStack(spacing: 6) {
                            Image(systemName: "folder.fill")
                                .foregroundColor(.orange)
                            Text(user.trackedReposText)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(height: size, alignment: .top)
                if let lastUpdate = user.lastUpdate, !isCompact {
                    Text("lastUpdate \(lastUpdate.formatted(date: .abbreviated, time: .shortened))")
                        .foregroundColor(.secondary)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .primary.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
}

#Preview {
        UserHeader(isCompact: true)
            .previewWithContainer()
}
