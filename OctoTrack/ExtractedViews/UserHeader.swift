//
//  UserHeader.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import SwiftUI

struct UserHeader: View {
    var user: User
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 24) {
            AsyncAvatarImage(avatar: user.avatar, size: 100)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 8) {
                Text(user.login)
                    .font(.title)
                    .fontWeight(.bold)
                
                Link(destination: URL(string: "https://github.com/\(user.login)")!) {
                    HStack(spacing: 6) {
                        Image(systemName: "link.circle.fill")
                            .foregroundColor(.blue)
                        Text("View on GitHub")
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "folder.fill")
                        .foregroundColor(.orange)
                    Text("\(user.repoList.count) repositories tracked")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 2)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : Color.white)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

#Preview {
    UserHeader(user: PreviewModels.previewUser)
}
