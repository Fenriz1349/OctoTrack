//
//  AuthenticationView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI

struct AuthenticationView: View {
    @State var viewModel: AuthenticationViewModel

    var body: some View {
            VStack(spacing: 20) {
                AsyncAvatarImage(avatarName: "", avatarUrl: "", size: 150)
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
