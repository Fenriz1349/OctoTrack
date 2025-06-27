//
//  AddRepositoryModal.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import SwiftUI

struct AddRepositoryModal: View {
    @StateObject var viewModel: AddRepoViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("repoAdd")
                    .font(.headline)
                    .padding(.top)

                CustomTextField(header: String(localized: "owner"),
                                placeholder: String(localized: "ownerExemple"),
                                text: $viewModel.owner,
                                type: .alphaNumber)

                CustomTextField(header: String(localized: "repoName"),
                                placeholder: String(localized: "repoExemple"),
                                text: $viewModel.repoName,
                                type: .alphaNumber)

                VStack(alignment: .leading, spacing: 10) {
                    Text("priority")
                        .fontWeight(.bold)
                        .padding(.horizontal, 4)
                    PriorityButtonsStack(selectedPriority: $viewModel.priority)
                }

                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button(action: {
                        Task {
                            await viewModel.getRepo()
                        }
                    },
                           label: {
                        CustomButtonLabel(iconLeading: .plus,
                                          message: "repoAdd"
                        )
                    }
                    )
                    // Disable button while form is not valid
                    .disabled(!viewModel.isFormValid)
                    .opacity(viewModel.isFormValid ? 1 : 0.6)
                }

                if viewModel.shouldShowFeedback {
                    FeedbackLabel(feedback: viewModel.feedback)
                }
                Spacer()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("close") {
                                dismiss()
                            }
                        }
                    }
            }
            .onChange(of: viewModel.feedback) {
                switch viewModel.feedback {
                case .addSuccess:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        viewModel.feedback = .none
                        dismiss()
                    }
                default:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        viewModel.feedback = .none
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    AddRepositoryModal(viewModel: AddRepoViewModel(dataManager: PreviewContainer.mockDataManager) )
    .previewWithContainer()
}
