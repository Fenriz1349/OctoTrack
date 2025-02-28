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
        ZStack {
            VStack(spacing: 20) {
                AsyncAvatarImage(avatar: AvatarProperties(name: "", url: ""), size: 150)
                Text("welcome on Octotrack")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                if viewModel.isAuthenticating {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding(.bottom, 40)
                } else {
                    Button(action: {
                        Task {
                            try await viewModel.login()
                        }
                    }) {
                        CustomButtonLabel(icon: nil, message: "Sign In to Githhub", color: .black)
                    }
                }
                if let error = viewModel.authError {
                    Text("Authentication error: \(error.localizedDescription)")
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 20)
                }
            }
            .onAppear {
                viewModel.checkAuthenticationStatus()
            }
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    AuthenticationView(viewModel: AuthenticationViewModel( { user in
        print("Utilisateur connecté")
    }))
}
