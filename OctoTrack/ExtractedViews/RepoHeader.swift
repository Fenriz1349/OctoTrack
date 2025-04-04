//
//  RepoHeader.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import SwiftUI

struct RepoHeader: View {
    var repository: Repository
    @Environment(\.colorScheme) private var colorScheme
    
    private var openPRCount: Int {
        repository.pullRequests?.filter { $0.state == "open" }.count ?? 0
    }
    
    private var closedPRCount: Int {
        repository.pullRequests?.filter { $0.state == "closed" }.count ?? 0
    }
    
    private var totalPRCount: Int {
        repository.pullRequests?.count ?? 0
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(repository.name)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                VStack {
                        HStack(spacing: 4) {
                            Image(systemName: (repository.isPrivate ?
                                               IconsName.lockClose : IconsName.lockOpen).rawValue)
                                .foregroundColor(.secondary)
                            Text(repository.isPrivate ?
                                 "private".localized : "public".localized)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(repository.isPrivate ? Color(UIColor.systemGray5) : Color(UIColor.green))
                        )
                }
            }
            
            HStack(spacing: 12) {
                AsyncAvatarImage(avatarName: repository.owner.login, avatarUrl: repository.owner.avatarURL, size: 36)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("owner".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(repository.owner.login)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                Link(destination: URL(string: "https://github.com/\(repository.owner.login)/\(repository.name)")!) {
                    HStack(spacing: 4) {
                        Image(systemName: IconsName.link.rawValue)
                            .foregroundColor(.blue)
                        Text("viewGithub".localized)
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("total".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(totalPRCount.description)
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                Divider()
                    .frame(height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("open".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(openPRCount.description)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                Divider()
                    .frame(height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("closed".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(closedPRCount.description)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                Divider()
                    .frame(height: 24)
                if let language = repository.language {
                    Text(language)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("createdAt".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(repository.createdAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                }
                
                if let updatedAt = repository.updatedAt {
                    Divider()
                        .frame(height: 24)
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("lastUpdated".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(updatedAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                    }
                }
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
    if let repository = PreviewContainer.getRepository() {
        return RepoHeader(repository: repository)
            .previewWithContainer()
    } else {
        return Text("Repository not found")
    }
}
