//
//  AccountView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 28/02/2025.
//

import SwiftUI

struct AccountView: View {
    @StateObject var viewModel: AccountViewModel
    @State private var headerRefreshID = 0

    var body: some View {
        VStack(spacing: 24) {
            if let user = viewModel.dataManager.activeUser {
                UserHeader(
                    user: user,
                    repoCount: viewModel.repositoryCount,
                    refreshID: headerRefreshID
                )
                .onChange(of: viewModel.dataManager.activeUser?.repoList.count) {
                    headerRefreshID += 1
                }
            }

            VStack(spacing: 16) {
                Button {
                    viewModel.resetButtonTapped()
                } label: {
                    CustomButtonLabel(
                        iconLeading: .trash,
                        message: "resetRepositoryList",
                        color: .customOrange
                    )
                }
                .alert("confirmation", isPresented: $viewModel.showingResetAlert) {
                    Button("cancel", role: .cancel) { }
                    Button("reset", role: .destructive) {
                        viewModel.resetUserRepository()
                    }
                } message: {
                    Text("resetAlert")
                }
                Button {
                    viewModel.signOut()
                } label: {
                    CustomButtonLabel(
                        iconLeading: .signOut,
                        message: "signOut",
                        color: .customRed
                    )
                }
                if viewModel.shouldShowFeedback {
                    FeedbackLabel(feedback: viewModel.feedback)
                }
            }
            .onChange(of: viewModel.feedback) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    viewModel.resetFeedback()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    let appViewModel = PreviewContainer.previewAppViewModel
    let viewModel = AccountViewModel(
        dataManager: PreviewContainer.mockDataManager,
        authenticationViewModel: appViewModel.authenticationViewModel,
        viewModelFactory: PreviewContainer.previewViewModelFactory
    )

    NavigationStack {
        AccountView(viewModel: viewModel)
    }
    .modelContainer(PreviewContainer.container)
}
