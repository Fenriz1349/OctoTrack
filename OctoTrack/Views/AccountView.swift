//
//  AccountView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 28/02/2025.
//

import SwiftUI

struct AccountView: View {
    @State private var appViewModel: AppViewModel

    init(appViewModel: AppViewModel) {
        self._appViewModel = State(initialValue: appViewModel)
    }

    var body: some View {
        VStack(spacing: 24) {
            if let user = appViewModel.userApp {
                UserHeader(user: user)
            } else {
                Text("userDataNotAvailable".localized)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 16) {
                Button {
                    Task {
                        do {
                            if let user = try? await appViewModel.authenticationViewModel.getUser() {
                                appViewModel.loginUser(user: user)
                            }
                        }
                    }
                } label: {
                    CustomButtonLabel(
                        icon: "arrow.clockwise",
                        message: "refreshUserData".localized,
                        color: Color.blue
                    )
                }

                Button {
                    appViewModel.userApp?.repoList = []
                } label: {
                    CustomButtonLabel(
                        icon: "trash",
                        message: "resetRepositoryList".localized,
                        color: Color.orange
                    )
                }

                Button {
                    appViewModel.authenticationViewModel.signOut()
                } label: {
                    CustomButtonLabel(
                        icon: "rectangle.portrait.and.arrow.right",
                        message: "signOut".localized,
                        color: Color.red
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .padding()
        .navigationTitle("account".localized)
    }
}

#Preview {
    NavigationView {
        AccountView(appViewModel: AppViewModel())
    }
}
