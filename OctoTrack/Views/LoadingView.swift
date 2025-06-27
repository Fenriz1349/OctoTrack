//
//  LoadingView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 06/06/2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var opacity: Double = 0

    var body: some View {

        VStack(spacing: 30) {
            Text("octotrack")
                .font(.title)
                .fontWeight(.bold)
            AsyncAvatarImage(avatarName: "", avatarUrl: "", size: 150)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .opacity(opacity)

            Text("loading")
                .font(.headline)
                .foregroundColor(.secondary)
                .opacity(opacity)

            ProgressView()
                .scaleEffect(1.2)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                opacity = 1.0
            }

            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    LoadingView()
}
