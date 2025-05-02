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
            HStack {
                AsyncAvatarImage(avatarName: repository.owner.login,
                                 avatarUrl: repository.owner.avatarURL, size: 50)
                Text(repository.name)
                Spacer()
                CustomButtonIcon(icon: repository.priority.icon, color: repository.priority.color)
                LockLabel(status: Status.getRepoStatus(repository), withText: false)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(5)
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
