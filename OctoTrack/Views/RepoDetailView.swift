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
    RepoDetailView(repository: PreviewModels.previewRepo)
}
