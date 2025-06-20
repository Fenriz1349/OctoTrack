//
//  AccountView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 28/02/2025.
//

import SwiftUI

struct AccountView: View {
    @State var appViewModel: AppViewModel
    @State private var showingResetAlert = false

    var body: some View {
        VStack(spacing: 24) {
            UserHeader()

            VStack(spacing: 16) {
                Button {
                    showingResetAlert = appViewModel.checkIfEmptyRepoList()
                } label: {
                    CustomButtonLabel(
                        iconLeading: .trash,
                        message: "resetRepositoryList",
                        color: .customOrange
                    )
                }
                .alert("confirmation", isPresented: $showingResetAlert) {
                    Button("cancel", role: .cancel) { }
                    Button("reset", role: .destructive) {
                        appViewModel.resetUserRepository()
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
                        color: .customRed
                    )
                }
                if appViewModel.feedback != .none {
                    FeedbackLabel(feedback: appViewModel.feedback)
                }
            }
            .onChange(of: appViewModel.feedback) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    appViewModel.feedback = .none
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
    AccountView(appViewModel: PreviewContainer.previewAppViewModel)
        .previewWithContainer()
}
