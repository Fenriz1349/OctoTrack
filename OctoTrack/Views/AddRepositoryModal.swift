//
//  AddRepositoryModal.swift
//  OctoTrack
//
//  Created by Julien Cotte on 21/02/2025.
//

import SwiftUI

struct AddRepositoryModal: View {
    @State private var viewModel: AddRepoViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(dataManager: UserDataManager) {
        self._viewModel = State(initialValue: AddRepoViewModel(dataManager: dataManager))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("repoAdd")
                    .font(.headline)
                    .padding(.top)
                
                CustomTextField(header: String(localized: "owner"),
                                color: .gray,
                                placeholder: "ownerExemple",
                                text: $viewModel.owner,
                                type: .alphaNumber
                )
                
                CustomTextField(header: String(localized: "repoName"),
                                color: .gray,
                                placeholder: "repoExemple",
                                text: $viewModel.repoName,
                                type: .alphaNumber
                )
                
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
                                          message: "repoAdd",
                                          color: .green
                        )
                    }
                    )
                    // Disable button while form is not valid
                    .disabled(!viewModel.isFormValid)
                    .opacity(viewModel.isFormValid ? 1 : 0.6)
                }
                
                if viewModel.feedback != .none {
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
                if !viewModel.feedback.isError {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        viewModel.feedback = .none
                        dismiss()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    AddRepositoryModal(dataManager: PreviewContainer.mockDataManager)
        .previewWithContainer()
}
