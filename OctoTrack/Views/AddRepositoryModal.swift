//
//  AddRepositoryModal.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import SwiftUI

struct AddRepositoryModal: View {
    @State private var viewModel = AddRepoViewModel()
    @State var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("repoAdd".localized)
                .font(.headline)
                .padding(.top)

            CustomTextField(
                header: "owner".localized,
                color: .gray,
                placeholder: "ownerExemple".localized,
                text: $viewModel.owner,
                type: .alphaNumber
            )

            CustomTextField(
                header: "repoName".localized,
                color: .gray,
                placeholder: "repoExemple".localized,
                text: $viewModel.repoName,
                type: .alphaNumber
            )

            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    Task {
                        let getRepo = await viewModel.getRepo()
                        switch getRepo {
                        case .success(let repo):
                            appViewModel.addRepoToUser(repo: repo)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                viewModel.resetFeedback()
                                dismiss()
                            }
                        case .failure:
                            break
                        }
                    }
                },
                label: {
                    CustomButtonLabel(
                        icon: IconsName.plus.rawValue,
                        message: "repoAdd".localized,
                        color: .green
                        )
                    }
                )
                // Disable button while form is not valid
                .disabled(!viewModel.isFormValid)
                .opacity(viewModel.isFormValid ? 1 : 0.6)
            }

            if viewModel.showFeedback {
                InfoLabel(message: viewModel.feedbackMessage, isSuccess: viewModel.isSuccess)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: 400)
    }
}

#Preview {
    AddRepositoryModal(appViewModel: AppViewModel())
}
