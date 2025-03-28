//
//  RepoRow.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import SwiftUI

struct RepoRow: View {
    let repository: Repository
    var body: some View {
        NavigationLink(destination: RepoDetailView(repository: repository) ) {
            HStack {
                AsyncAvatarImage(avatarName: repository.owner.login,
                                 avatarUrl: repository.owner.avatarURL, size: 50)
                Text(repository.name)
                Text(repository.isPrivate ? "private".localized
                     : "public".localized)
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    if let repository = PreviewContainer.getRepository() {
        return RepoRow(repository: repository)
            .previewWithContainer()
    } else {
        return Text("Repository not found")
    }
}
