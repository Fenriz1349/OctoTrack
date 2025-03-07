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
            Text("Ajouter un dépôt")
                .font(.headline)
                .padding(.top)

            CustomTextField(
                header: "Propriétaire",
                color: .gray,
                placeholder: "ex: octocat",
                text: $viewModel.owner,
                type: .alphaNumber
            )

            CustomTextField(
                header: "Nom du dépôt",
                color: .gray,
                placeholder: "ex: Hello-World",
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
                        icon: "plus.circle.fill",
                        message: "Ajouter le dépôt",
                        color: .green
                        )
                    }
                )
                // Permet de désactiver le bouton tant que les 2 champs sont vide
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
