//
//  UserHeader.swift
//  OctoTrack
//
//  Created by Julien Cotte on 14/02/2025.
//

import SwiftUI

struct UserHeader: View {
    var user: User
    var body: some View {
        HStack {
            AsyncAvatarImage(avatar: user.avatar, size: 150)
            VStack(alignment: .leading, spacing: 20) {
                Text(user.login)
                Link("Github", destination: URL(string: "https://github.com/users/" + user.login)!)
                Text("Repo suivis: \(user.repoList.count)")
            }
        }
    }
}

#Preview {
    UserHeader(user: PreviewModels.previewUser)
}
