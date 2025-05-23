//
//  AddRepositoryModal.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import SwiftUI
import SwiftData

struct AddRepositoryModal: View {
    @State private var viewModel: AddRepoViewModel
    @Environment(\.dismiss) private var dismiss

    init(dataManager: UserDataManager) {
           self._viewModel = State(initialValue: AddRepoViewModel(dataManager: dataManager))
       }

    var body: some View {
        VStack(spacing: 20) {
            Text("repoAdd")
                .font(.headline)
                .padding(.top)

            CustomTextField(
                header: "owner",
                color: .gray,
                placeholder: "ownerExemple",
                text: $viewModel.owner,
                type: .alphaNumber
            )

            CustomTextField(
                header: "repoName",
                color: .gray,
                placeholder: "repoExemple",
                text: $viewModel.repoName,
                type: .alphaNumber
            )
            PriorityButtonsStack(selectedPriority: $viewModel.priority)
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    Task {
                        let getRepo = await viewModel.getRepo()
                        switch getRepo {
                        case .success(let repo):
                            repo.priority = viewModel.priority
                            viewModel.dataManager.storeNewRepo(repo)
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
                        iconLeading: .plus,
                        message: "repoAdd",
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
    }
}

#Preview {
    AddRepositoryModal(dataManager: PreviewContainer.mockDataManager)
        .previewWithContainer()
}
