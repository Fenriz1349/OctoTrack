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
                UserHeader(user: user)
            }
            NavigationLink(destination: AddRepositoryModal(dataManager: viewModel.dataManager)) {
                CustomButtonLabel(iconLeading: IconsName.plus.rawValue,
                                  message: "repoAdd".localized,
                                  color: .black)
                .padding(.horizontal, 30)
            }
            List {
                ForEach(viewModel.activeUser?.repoList ?? []) { repository in
                    NavigationLink(destination: RepoDetailView(repository: repository,
                                                               dataManager: viewModel.dataManager)) {
                        RepoRow(repository: repository)
                    }
                    .listRowInsets(EdgeInsets())
                    .swipeActions(edge: .trailing) {
                       Button(role: .destructive) {
                           viewModel.deleteRepository(repository)
                       } label: {
                           CustomButtonIcon(icon: "trash", color: .red)
                       }
                   }
                }
            }
            .refreshable {
                viewModel.orderRepositories()
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Repository.self, configurations: config)
        let mockDataManager = UserDataManager(modelContext: ModelContext(container))
        return RepoListView(viewModel: RepoListViewModel(dataManager: mockDataManager))
            .previewWithContainer()
    } catch {
        return Text("Erreur: \(error.localizedDescription)")
    }
}
