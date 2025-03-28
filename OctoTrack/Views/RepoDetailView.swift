//
//  RepoDetailView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI

struct RepoDetailView: View {
    let repository: Repository
    var body: some View {
        Text(repository.name)
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
