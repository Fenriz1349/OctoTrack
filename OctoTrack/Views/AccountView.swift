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
                Text("userDataNotAvailable".localized)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 16) {
                Button {
                    showingResetAlert = true
                } label: {
                    CustomButtonLabel(
                        iconLeading: IconsName.trash.rawValue,
                        message: "resetRepositoryList".localized,
                        color: Color.orange
                    )
                }
                .alert("confirmation".localized, isPresented: $showingResetAlert) {
                    Button("cancel".localized, role: .cancel) { }
                    Button("reset".localized, role: .destructive) {
                        appViewModel.dataManager.resetAllRepositories()
                    }
                } message: {
                    Text("resetAlert".localized)
                }
                Button {
                    appViewModel.authenticationViewModel.signOut()
                } label: {
                    CustomButtonLabel(
                        iconLeading: IconsName.signOut.rawValue,
                        message: "signOut".localized,
                        color: Color.red
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            Spacer()
        }
        .padding()
        .navigationTitle("account".localized)
    }
}

#Preview {
    NavigationView {
        let viewModel = PreviewContainer.previewAppViewModel
        return AccountView(appViewModel: viewModel)
            .previewWithContainer()
    }
}
