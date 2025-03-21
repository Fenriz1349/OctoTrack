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
                AsyncAvatarImage(avatar: AvatarProperties(name: "", url: ""), size: 150)
                Text("welcome".localized)
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

                if let error = viewModel.authError {
                    Text("authenticationError".localized(error.localizedDescription))
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 20)
                }
            }
            .padding(.horizontal, 40)
        }
}

#Preview {
    AuthenticationView(viewModel: AuthenticationViewModel( onLoginSucceed: { user in
        print("connected".localized(user.login))
    }, onLogoutCompleted: {}))
}
