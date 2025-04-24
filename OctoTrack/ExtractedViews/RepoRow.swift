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
            HStack(alignment: .center, spacing: 10) {
                AsyncAvatarImage(avatarName: repository.owner.login,
                                 avatarUrl: repository.owner.avatarURL, size: 50)
                CustomButtonIcon(icon: repository.priority.icon, color: repository.priority.color)
                Text(repository.name)
                Text(repository.isPrivate ? "private".localized
                     : "public".localized)
                Spacer()
                Image(systemName: IconsName.chevron.rawValue)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
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
