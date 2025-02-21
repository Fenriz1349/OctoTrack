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

    @State var repo: Repository?
    var body: some View {
        VStack {
            Text("Ajouter un Repo")
            HStack {
                TextField("owner", text: $viewModel.owner)
                TextField("repo", text: $viewModel.repoName)
            }
            Button(action: {
                Task {
                    await repo = viewModel.getRepo()
                    if let repo = repo {
                        appViewModel.userApp?.repoList.append(repo)
                    }
                }
            }) {
                CustomButtonLabel(icon: nil, message: "ajouter", color: .green)
            }
            TextField("chercher les repos de :", text: $viewModel.owner)
            if let repo = repo {
                Text("Repo : \(repo.id) ajouté")
            }
        }
    }
}

#Preview {
    AddRepositoryModal(appViewModel: AppViewModel())
}
