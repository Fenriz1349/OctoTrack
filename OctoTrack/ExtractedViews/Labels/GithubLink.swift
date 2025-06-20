//
//  GithubLink.swift
//  OctoTrack
//
//  Created by Julien Cotte on 02/05/2025.
//

import SwiftUI

struct GithubLink: View {
    let link: String
    var body: some View {
        Link(destination: URL(string: link)!) {
            HStack {
                Image(systemName: IconsName.link.rawValue)
                Text("viewOnGithub")
                    .font(.system(size: 14))
            }
            .foregroundColor(.accentColor)
            .cornerRadius(8)
        }
    }
}

#Preview {
    GithubLink(link: "test")
}
