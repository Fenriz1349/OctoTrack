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
                Text("welcome")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                CustomTextField(color: Color(UIColor.secondarySystemBackground),
                                placeholder: "mailAdress",
                                text: $viewModel.username,
                                type: .email)
                CustomTextField(color: Color(UIColor.secondarySystemBackground),
                                placeholder: "password",
                                text: $viewModel.password,
                                type: .password)
                Button(action: {
                    Task {
                        try await viewModel.login()
                    }
                }) {
                    CustomButtonLabel(icon: nil, message: "login", color: .black)
                }
//                VStack {
//                    if let message = viewModel.authenticationErrorMessage {
//                        InfoLabel(message: message, isError: authenticationViewModel.autenticationIsError)
//                            .transition(.move(edge: .top).combined(with: .opacity))
//                            .task {
//                                // Affiche le label pendant 5 secondes puis réinstalle la variable à false
//                                try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
//                                authenticationViewModel.authenticationErrorMessage  = nil
//                            }
//                    }
//                }
//                .frame(height:80)
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    AuthenticationView(viewModel: AuthenticationViewModel( { user in
        print("Utilisateur connecté")
    }))
}
