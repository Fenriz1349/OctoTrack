//
//  PRDetailView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 04/04/2025.
//

import SwiftUI

struct PRDetailView: View {
    let pullRequest: PullRequest
    var body: some View {
        Text("account".localized)
    }
}

#Preview {
    PRDetailView(pullRequest: PreviewPullRequests.architecturePRs.first!)
}
