//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI
import SwiftData

struct RepoListView: View {
    @State var viewModel: RepoListViewModel

    var body: some View {
        NavigationStack {
            if let user = viewModel.activeUser {
                UserHeader(user: user, repositories: viewModel.repositories)
            }
            NavigationLink(destination: AddRepositoryModal(dataManager: viewModel.dataManager)) {
                CustomButtonLabel(icon: IconsName.plus.rawValue,
                                  message: "repoAdd".localized,
                                  color: .black)
                .padding(.horizontal, 30)
            }
            ScrollView {
                ForEach(viewModel.repositories) { repository in
                    RepoRow(repository: repository)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteRepository(repository)
                            } label: {
                                CustomButtonIcon(icon: "trash", color: .red)
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Repository.self, configurations: config)
    let mockDataManager = UserDataManager(modelContext: ModelContext(container))
    RepoListView(viewModel: RepoListViewModel(dataManager: mockDataManager))
        .previewWithContainer()
}
