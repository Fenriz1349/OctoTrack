//
//  AuthenticationView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI

struct AuthenticationView: View {
    @State var viewModel: AuthenticationViewModel
    @State private var isAnimating = false
    @State private var opacity: Double = 0

    var body: some View {
            VStack(spacing: 20) {
                Text("octotrack")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                AsyncAvatarImage(avatarName: "", avatarUrl: "", size: 150)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .opacity(opacity)
                Text("welcome")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                if viewModel.isAuthenticating {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding(.bottom, 40)
                } else {
                    AuthButtonsStack(
                        status: viewModel.authenticationState,
                        onLogin: { Task { try await viewModel.login() } },
                        onSignOut: { viewModel.signOut() }
                    )
                }
                if viewModel.feedback != .none {
                    FeedbackLabel(feedback: viewModel.feedback)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.6)) {
                    opacity = 1.0
                }
                
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
            .onChange(of: viewModel.feedback) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    viewModel.feedback = .none
                }
            }
            .padding(.horizontal, 40)
        }
}

#Preview {
    AuthenticationView(viewModel: AuthenticationViewModel( onLoginSucceed: { user in
        print("connected\(user.login)")
    }, onLogoutCompleted: {}))
}
