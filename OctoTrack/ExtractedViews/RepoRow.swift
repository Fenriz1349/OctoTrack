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
                AsyncAvatarImage(avatar: repository.avatar, size: 50)
                Text(repository.name)
                Text(repository.isPrivate ? "private".localized
                     : "public".localized)
                Spacer()
                Image(systemName: "chevron.forward")
                    .padding(.leading, 5)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    RepoRow(repository: PreviewModels.repositories.first!)
}
