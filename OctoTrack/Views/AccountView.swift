//
//  AccountView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 28/02/2025.
//

import SwiftUI

struct AccountView: View {
    @State private var appViewModel: AppViewModel
    @State private var showingResetAlert = false

    init(appViewModel: AppViewModel) {
        self._appViewModel = State(initialValue: appViewModel)
    }

    var body: some View {
        VStack(spacing: 24) {
            if let user = appViewModel.userApp {
                UserHeader(user: user)
            } else {
                Text("userDataNotAvailable")
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 16) {
                Button {
                    showingResetAlert = true
                } label: {
                    CustomButtonLabel(
                        iconLeading: .trash,
                        message: "resetRepositoryList",
                        color: Color.orange
                    )
                }
                .alert("confirmation", isPresented: $showingResetAlert) {
                    Button("cancel", role: .cancel) { }
                    Button("reset", role: .destructive) {
                        appViewModel.dataManager.resetAllRepositories()
                    }
                } message: {
                    Text("resetAlert")
                }
                Button {
                    appViewModel.authenticationViewModel.signOut()
                } label: {
                    CustomButtonLabel(
                        iconLeading: .signOut,
                        message: "signOut",
                        color: Color.red
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            Spacer()
        }
        .padding()
        .navigationTitle("account")
    }
}

#Preview {
    AccountView(appViewModel: PreviewContainer.previewAppViewModel)
        .previewWithContainer()
}
