//
//  ContentView.swift
//  OctoTrack
//
//  Created by Julien Cotte on 12/02/2025.
//

import SwiftUI
import SwiftData

struct RepoListView: View {
    @StateObject var viewModel: RepoListViewModel
    @State private var headerRefreshID = 0
    
    var body: some View {
        VStack {
            UserHeader(
                user: viewModel.dataManager.activeUser!,
                repoCount: viewModel.selectedRepositories.count,
                refreshID: headerRefreshID,
                isCompact: true
            )
            .onChange(of: viewModel.selectedRepositories.count) {
                headerRefreshID += 1  // ← BOOM, refresh du header !
            }
            PriorityButtonsStack(selectedPriority: $viewModel.selectedPriority, showAll: true)
            List {
                ForEach(viewModel.selectedRepositories) { repository in
                    NavigationLink(destination: RepoDetailView(viewModel: viewModel.viewModelFactory.makeRepoDetailsViewModel(repository: repository))) {
                        RepoRow(repository: repository)
                    }
                    .listRowInsets(EdgeInsets())
                    .swipeActions(edge: .trailing) {
                       Button(role: .destructive) {
                           viewModel.deleteRepository(repository)
                           headerRefreshID += 1 
                       } label: {
                           CustomButtonIcon(icon: .trash, color: .customRed)
                       }
                   }
                }
            }
            .listStyle(.plain)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    let dataManager = UserDataManager(modelContext: PreviewContainer.container.mainContext)
    let appViewModel = AppViewModel(dataManager: dataManager)
    let viewModelFactory = ViewModelFactory(dataManager: dataManager)
    RepoListView(viewModel: RepoListViewModel(
        dataManager: PreviewContainer.previewAppViewModel.dataManager, viewModelFactory: viewModelFactory)
    )
    .previewWithContainer()
}
